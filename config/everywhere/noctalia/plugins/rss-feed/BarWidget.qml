import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Services.UI
import qs.Widgets

Rectangle {
    id: root

    property var pluginApi: null

    property ShellScreen screen
    property string widgetId: ""
    property string section: ""

    readonly property bool isVertical: Settings.data.bar.position === "left" || Settings.data.bar.position === "right"

    // Configuration
    property var cfg: pluginApi?.pluginSettings || ({})
    property var defaults: pluginApi?.manifest?.metadata?.defaultSettings || ({})

    readonly property var feeds: cfg.feeds || defaults.feeds || []
    readonly property int updateInterval: cfg.updateInterval ?? defaults.updateInterval ?? 600
    readonly property int maxItemsPerFeed: cfg.maxItemsPerFeed ?? defaults.maxItemsPerFeed ?? 10
    readonly property bool showOnlyUnread: cfg.showOnlyUnread ?? defaults.showOnlyUnread ?? false
    readonly property bool markAsReadOnClick: cfg.markAsReadOnClick ?? defaults.markAsReadOnClick ?? true
    readonly property var readItems: cfg.readItems || defaults.readItems || []

    // Watch for changes in readItems and cfg to update unread count
    onCfgChanged: {
        console.log("RSS Feed BarWidget: Config changed");
        updateUnreadCount();
    }
    
    onReadItemsChanged: {
        console.log("RSS Feed BarWidget: readItems changed, count:", readItems.length);
        updateUnreadCount();
    }

    // State
    property var allItems: []
    property int unreadCount: 0
    property bool loading: false
    property bool error: false

    // Timer to periodically reload settings (to catch changes from Panel)
    Timer {
        id: settingsReloadTimer
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            if (pluginApi && pluginApi.pluginSettings) {
                const newCfg = pluginApi.pluginSettings;
                const newReadItems = newCfg.readItems || defaults.readItems || [];
                if (JSON.stringify(readItems) !== JSON.stringify(newReadItems)) {
                    cfg = newCfg;
                    console.log("RSS Feed BarWidget: Settings updated, readItems count:", newReadItems.length);
                }
            }
        }
    }

    // Expose state to pluginApi for Panel access
    onAllItemsChanged: {
        if (pluginApi) {
            try {
                if (!pluginApi.sharedData) {
                    pluginApi.sharedData = {};
                }
                pluginApi.sharedData.allItems = allItems;
                console.log("RSS Feed BarWidget: Shared", allItems.length, "items to Panel");
            } catch (e) {
                console.error("RSS Feed BarWidget: Error sharing data:", e);
            }
            updateUnreadCount();
        }
    }

    function updateUnreadCount() {
        let count = 0;
        for (let i = 0; i < allItems.length; i++) {
            const item = allItems[i];
            if (!readItems.includes(item.guid || item.link)) {
                count++;
            }
        }
        unreadCount = count;
    }

    // Expose functions
    Component.onCompleted: {
        console.log("RSS Feed: Widget loaded");
        console.log("RSS Feed: Feeds configured:", feeds.length);
        
        if (pluginApi) {
            try {
                // Initialize sharedData if it doesn't exist
                if (!pluginApi.sharedData) {
                    pluginApi.sharedData = {};
                }
                pluginApi.sharedData.allItems = [];
                pluginApi.triggerRefresh = fetchAllFeeds;
                pluginApi.markAsRead = markItemAsRead;
                pluginApi.markAllAsRead = markAllAsRead;
                console.log("RSS Feed: pluginApi initialized, sharedData ready");
            } catch (e) {
                console.error("RSS Feed: Error initializing pluginApi:", e);
            }
        } else {
            console.warn("RSS Feed: pluginApi is null!");
        }
    }

    implicitWidth: Math.max(60, isVertical ? (Style.capsuleHeight || 32) : contentWidth)
    implicitHeight: Math.max(32, isVertical ? contentHeight : (Style.capsuleHeight || 32))
    radius: Style.radiusM || 8
    color: Style.capsuleColor || "#1E1E1E"
    border.color: Style.capsuleBorderColor || "#2E2E2E"
    border.width: Style.capsuleBorderWidth || 1

    readonly property real contentWidth: rowLayout.implicitWidth + (Style.marginM || 8) * 2
    readonly property real contentHeight: rowLayout.implicitHeight + (Style.marginM || 8) * 2

    // Timer for periodic updates
    Timer {
        id: updateTimer
        interval: updateInterval * 1000
        running: feeds.length > 0
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            console.log("RSS Feed: Timer triggered, fetching feeds");
            fetchAllFeeds();
        }
    }

    // Process for fetching feeds
    Process {
        id: fetchProcess
        running: false
        stdout: StdioCollector {}
        stderr: StdioCollector {}
        
        property bool isFetching: false
        property string currentFeedUrl: ""
        property int currentFeedIndex: 0
        property var tempItems: []
        
        onExited: exitCode => {
            if (!isFetching) return;
            
            if (exitCode !== 0) {
                console.error("RSS Feed: curl failed for", currentFeedUrl, "with code", exitCode);
                fetchNextFeed();
                return;
            }
            
            if (!stdout.text || stdout.text.trim() === "") {
                console.error("RSS Feed: Empty response for", currentFeedUrl);
                fetchNextFeed();
                return;
            }
            
            try {
                const items = parseRSSFeed(stdout.text, currentFeedUrl);
                console.log("RSS Feed: Parsed", items.length, "items from", currentFeedUrl);
                tempItems = tempItems.concat(items);
                fetchNextFeed();
            } catch (e) {
                console.error("RSS Feed: Parse error for", currentFeedUrl, ":", e);
                fetchNextFeed();
            }
        }
    }

    function fetchAllFeeds() {
        if (feeds.length === 0) {
            console.log("RSS Feed: No feeds configured");
            return;
        }
        
        if (fetchProcess.isFetching) {
            console.log("RSS Feed: Already fetching");
            return;
        }
        
        console.log("RSS Feed: Starting fetch for", feeds.length, "feeds");
        loading = true;
        error = false;
        fetchProcess.tempItems = [];
        fetchProcess.currentFeedIndex = 0;
        fetchNextFeed();
    }

    function fetchNextFeed() {
        if (fetchProcess.currentFeedIndex >= feeds.length) {
            // Done fetching all feeds
            fetchProcess.isFetching = false;
            loading = false;
            
            // Sort by date and limit
            let sorted = fetchProcess.tempItems.sort((a, b) => {
                return new Date(b.pubDate) - new Date(a.pubDate);
            });
            
            allItems = sorted;
            console.log("RSS Feed: Total items:", allItems.length);
            updateUnreadCount();
            return;
        }
        
        const feed = feeds[fetchProcess.currentFeedIndex];
        fetchProcess.currentFeedUrl = feed.url;
        fetchProcess.currentFeedIndex++;
        
        console.log("RSS Feed: Fetching", fetchProcess.currentFeedUrl);
        
        fetchProcess.command = [
            "curl", "-s", "-L",
            "-H", "User-Agent: Mozilla/5.0",
            "--max-time", "10",
            fetchProcess.currentFeedUrl
        ];
        fetchProcess.isFetching = true;
        fetchProcess.running = true;
    }

    function parseRSSFeed(xml, feedUrl) {
        const items = [];
        const feedName = feeds.find(f => f.url === feedUrl)?.name || feedUrl;
        
        // Simple RSS/Atom parser
        // Extract <item> or <entry> elements
        const itemRegex = /<(?:item|entry)[^>]*>([\s\S]*?)<\/(?:item|entry)>/gi;
        let match;
        
        let count = 0;
        while ((match = itemRegex.exec(xml)) !== null && count < maxItemsPerFeed) {
            const itemXml = match[1];
            
            const title = extractTag(itemXml, 'title') || 'Untitled';
            const link = extractTag(itemXml, 'link') || extractAttr(itemXml, 'link', 'href') || '';
            const description = extractTag(itemXml, 'description') || extractTag(itemXml, 'summary') || extractTag(itemXml, 'content') || '';
            const pubDate = extractTag(itemXml, 'pubDate') || extractTag(itemXml, 'published') || extractTag(itemXml, 'updated') || new Date().toISOString();
            const guid = extractTag(itemXml, 'guid') || extractTag(itemXml, 'id') || link;
            
            items.push({
                feedName: feedName,
                feedUrl: feedUrl,
                title: cleanText(title),
                link: link,
                description: cleanText(description).substring(0, 200),
                pubDate: pubDate,
                guid: guid
            });
            count++;
        }
        
        return items;
    }

    function extractTag(xml, tag) {
        const regex = new RegExp(`<${tag}[^>]*>([\\s\\S]*?)<\/${tag}>`, 'i');
        const match = xml.match(regex);
        return match ? match[1] : '';
    }

    function extractAttr(xml, tag, attr) {
        const regex = new RegExp(`<${tag}[^>]*${attr}="([^"]*)"`, 'i');
        const match = xml.match(regex);
        return match ? match[1] : '';
    }

    function cleanText(text) {
        if (!text) return '';
        // Remove CDATA
        text = text.replace(/<!\[CDATA\[([\s\S]*?)\]\]>/g, '$1');
        // Remove HTML tags
        text = text.replace(/<[^>]+>/g, ' ');
        // Decode numeric HTML entities (&#8220; etc)
        text = text.replace(/&#(\d+);/g, function(match, dec) {
            return String.fromCharCode(dec);
        });
        // Decode hex HTML entities (&#x201C; etc)
        text = text.replace(/&#x([0-9A-Fa-f]+);/g, function(match, hex) {
            return String.fromCharCode(parseInt(hex, 16));
        });
        // Decode common HTML entities
        text = text.replace(/&lt;/g, '<');
        text = text.replace(/&gt;/g, '>');
        text = text.replace(/&amp;/g, '&');
        text = text.replace(/&quot;/g, '"');
        text = text.replace(/&#39;/g, "'");
        text = text.replace(/&apos;/g, "'");
        text = text.replace(/&nbsp;/g, ' ');
        text = text.replace(/&mdash;/g, '\u2014');
        text = text.replace(/&ndash;/g, '\u2013');
        text = text.replace(/&ldquo;/g, '\u201C');
        text = text.replace(/&rdquo;/g, '\u201D');
        text = text.replace(/&lsquo;/g, '\u2018');
        text = text.replace(/&rsquo;/g, '\u2019');
        text = text.replace(/&hellip;/g, '\u2026');
        // Clean whitespace
        text = text.replace(/\s+/g, ' ').trim();
        return text;
    }

    function markItemAsRead(guid) {
        if (!pluginApi) return;
        
        if (!readItems.includes(guid)) {
            const newReadItems = readItems.slice();
            newReadItems.push(guid);
            pluginApi.pluginSettings.readItems = newReadItems;
            pluginApi.saveSettings();
            updateUnreadCount();
        }
    }

    function markAllAsRead() {
        if (!pluginApi) return;
        
        const newReadItems = allItems.map(item => item.guid || item.link);
        pluginApi.pluginSettings.readItems = newReadItems;
        pluginApi.saveSettings();
        updateUnreadCount();
    }

    RowLayout {
        id: rowLayout
        anchors.centerIn: parent
        spacing: Style.marginS || 6

        Text {
            text: "\uf09e"
            font.family: "Symbols Nerd Font"
            font.pixelSize: Style.fontSizeL || 18
            color: error ? (Style.errorColor || "#FF5555") : (loading ? (Style.textColorSecondary || "#BBBBBB") : (Style.textColor || "#FFFFFF"))
            
            NumberAnimation on opacity {
                running: loading
                from: 0.3
                to: 1.0
                duration: 1000
                loops: Animation.Infinite
                easing.type: Easing.InOutQuad
            }
        }

        Rectangle {
            visible: unreadCount > 0
            Layout.preferredWidth: badgeText.implicitWidth + 8
            Layout.preferredHeight: 18
            radius: 9
            color: Style.accentColor || "#FF6B6B"

            Text {
                id: badgeText
                anchors.centerIn: parent
                text: unreadCount > 99 ? "99+" : unreadCount.toString()
                font.pixelSize: 10
                font.bold: true
                color: "#FFFFFF"
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (pluginApi) {
                pluginApi.openPanel(screen);
            }
        }
    }
}
