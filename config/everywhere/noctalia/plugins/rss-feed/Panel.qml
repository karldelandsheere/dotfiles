import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Io
import qs.Commons
import qs.Widgets

Item {
    id: root

    property var pluginApi: null
    
    readonly property var geometryPlaceholder: panelContainer
    property real contentPreferredWidth: 500 * Style.uiScaleRatio
    property real contentPreferredHeight: 650 * Style.uiScaleRatio
    readonly property bool allowAttach: true
    
    anchors.fill: parent

    property var cfg: pluginApi?.pluginSettings || ({})
    property var defaults: pluginApi?.manifest?.metadata?.defaultSettings || ({})

    readonly property var feeds: cfg.feeds || defaults.feeds || []
    readonly property int updateInterval: cfg.updateInterval ?? defaults.updateInterval ?? 600
    readonly property int maxItemsPerFeed: cfg.maxItemsPerFeed ?? defaults.maxItemsPerFeed ?? 10
    readonly property bool showOnlyUnread: cfg.showOnlyUnread ?? defaults.showOnlyUnread ?? false
    readonly property bool markAsReadOnClick: cfg.markAsReadOnClick ?? defaults.markAsReadOnClick ?? true
    property var readItems: cfg.readItems || defaults.readItems || []

    property var allItems: []
    property var displayItems: []
    property bool loading: false

    // Timer to reload settings after save
    Timer {
        id: settingsReloadTimer
        interval: 200
        running: false
        repeat: false
        onTriggered: {
            if (pluginApi && pluginApi.pluginSettings) {
                cfg = pluginApi.pluginSettings;
                readItems = cfg.readItems || defaults.readItems || [];
                console.log("RSS Feed Panel: Settings reloaded, readItems count:", readItems.length);
                updateDisplayItems();
            }
        }
    }

    // Process for fetching feeds directly in Panel
    Process {
        id: fetchProcess
        running: false
        stdout: StdioCollector {}
        stderr: StdioCollector {}
        
        property bool isFetching: false
        property var tempItems: []
        property int currentFeedIndex: 0
        property string currentFeedUrl: ""
        
        onExited: exitCode => {
            if (exitCode === 0 && stdout.text) {
                const items = parseRSSFeed(stdout.text, currentFeedUrl);
                tempItems = tempItems.concat(items);
                console.log("RSS Feed Panel: Fetched", items.length, "items from", currentFeedUrl);
            }
            
            fetchNextFeed();
        }
    }

    Component.onCompleted: {
        console.log("RSS Feed Panel: Component loaded");
        console.log("RSS Feed Panel: Feeds configured:", feeds.length);
        
        // Start fetching immediately
        if (feeds.length > 0) {
            Qt.callLater(fetchAllFeeds);
        }
    }

    onVisibleChanged: {
        if (visible) {
            console.log("RSS Feed Panel: Opened");
            // Refresh on open
            if (feeds.length > 0 && !loading) {
                fetchAllFeeds();
            }
        }
    }

    function fetchAllFeeds() {
        if (feeds.length === 0) {
            console.log("RSS Feed Panel: No feeds configured");
            return;
        }
        
        if (fetchProcess.isFetching) {
            console.log("RSS Feed Panel: Already fetching");
            return;
        }
        
        console.log("RSS Feed Panel: Starting fetch for", feeds.length, "feeds");
        loading = true;
        fetchProcess.tempItems = [];
        fetchProcess.currentFeedIndex = 0;
        fetchNextFeed();
    }

    function fetchNextFeed() {
        if (fetchProcess.currentFeedIndex >= feeds.length) {
            // Done fetching all feeds
            fetchProcess.isFetching = false;
            loading = false;
            
            // Sort by date and update
            let sorted = fetchProcess.tempItems.sort((a, b) => {
                return new Date(b.pubDate) - new Date(a.pubDate);
            });
            
            allItems = sorted;
            console.log("RSS Feed Panel: Total items:", allItems.length);
            updateDisplayItems();
            return;
        }
        
        const feed = feeds[fetchProcess.currentFeedIndex];
        fetchProcess.currentFeedUrl = feed.url;
        fetchProcess.currentFeedIndex++;
        
        console.log("RSS Feed Panel: Fetching", fetchProcess.currentFeedUrl);
        
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
                title: cleanHTML(title),
                description: cleanHTML(description).substring(0, 200),
                link: link,
                pubDate: pubDate,
                guid: guid
            });
            
            count++;
        }
        
        return items;
    }

    function extractTag(xml, tag) {
        const regex = new RegExp(`<${tag}[^>]*>([\\s\\S]*?)<\\/${tag}>`, 'i');
        const match = regex.exec(xml);
        return match ? match[1].trim() : '';
    }

    function extractAttr(xml, tag, attr) {
        const regex = new RegExp(`<${tag}[^>]*${attr}=["']([^"']+)["']`, 'i');
        const match = regex.exec(xml);
        return match ? match[1] : '';
    }

    function cleanHTML(text) {
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

    // Remove the Timer that tries to sync with BarWidget
    onAllItemsChanged: updateDisplayItems()
    onShowOnlyUnreadChanged: updateDisplayItems()
    onReadItemsChanged: {
        console.log("RSS Feed Panel: readItems changed, count:", readItems.length);
        updateDisplayItems();
    }

    function updateDisplayItems() {
        console.log("RSS Feed Panel: updateDisplayItems called, allItems.length:", allItems.length);
        if (showOnlyUnread) {
            displayItems = allItems.filter(item => {
                return !readItems.includes(item.guid || item.link);
            });
        } else {
            displayItems = allItems.slice();
        }
        console.log("RSS Feed Panel: displayItems.length:", displayItems.length);
    }

    function markAsRead(guid) {
        if (!guid) {
            return;
        }
        
        console.log("RSS Feed Panel: Marking as read:", guid);
        
        // Get current readItems from settings
        const currentReadItems = cfg.readItems || defaults.readItems || [];
        
        if (currentReadItems.includes(guid)) {
            console.log("RSS Feed Panel: Already marked as read");
            return;
        }
        
        // Add to readItems array - create new array
        let newReadItems = [];
        for (let i = 0; i < currentReadItems.length; i++) {
            newReadItems.push(currentReadItems[i]);
        }
        newReadItems.push(guid);
        
        console.log("RSS Feed Panel: New readItems array:", JSON.stringify(newReadItems));
        
        // Save to settings using the same pattern as Settings.qml
        if (pluginApi) {
            if (!pluginApi.pluginSettings.readItems) {
                pluginApi.pluginSettings.readItems = [];
            }
            pluginApi.pluginSettings.readItems = newReadItems;
            pluginApi.saveSettings();
            console.log("RSS Feed Panel: Settings saved, readItems count:", newReadItems.length);
            
            // Trigger reload timer
            settingsReloadTimer.restart();
        }
    }

    function markAllAsRead() {
        if (allItems.length === 0) {
            return;
        }
        
        console.log("RSS Feed Panel: Marking all as read, count:", allItems.length);
        
        // Get current readItems from settings
        const currentReadItems = cfg.readItems || defaults.readItems || [];
        
        // Collect all guids - create new array
        let newReadItems = [];
        for (let i = 0; i < currentReadItems.length; i++) {
            newReadItems.push(currentReadItems[i]);
        }
        
        for (let i = 0; i < allItems.length; i++) {
            const guid = allItems[i].guid || allItems[i].link;
            if (guid && !newReadItems.includes(guid)) {
                newReadItems.push(guid);
            }
        }
        
        console.log("RSS Feed Panel: New readItems array length:", newReadItems.length);
        
        // Save to settings using the same pattern as Settings.qml
        if (pluginApi) {
            if (!pluginApi.pluginSettings.readItems) {
                pluginApi.pluginSettings.readItems = [];
            }
            pluginApi.pluginSettings.readItems = newReadItems;
            pluginApi.saveSettings();
            console.log("RSS Feed Panel: All marked as read, readItems count:", newReadItems.length);
            
            // Trigger reload timer
            settingsReloadTimer.restart();
        }
    }

    function refresh() {
        if (pluginApi?.triggerRefresh) {
            pluginApi.triggerRefresh();
        }
    }

    Rectangle {
        id: panelContainer
        anchors.fill: parent
        color: Style.backgroundColor || "#1E1E1E"
        radius: Style.radiusL || 12

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Style.marginM || 12
            spacing: Style.marginM || 12

            // Header
            RowLayout {
                Layout.fillWidth: true
                spacing: Style.marginM || 12

                Text {
                    text: pluginApi?.tr("widget.title", "RSS Feeds") || "RSS Feeds"
                    font.pixelSize: Style.fontSizeL || 18
                    font.bold: true
                    color: Style.textColor || "#FFFFFF"
                    Layout.fillWidth: true
                }

                Text {
                    visible: displayItems.length > 0 && showOnlyUnread
                    text: displayItems.length + " unread"
                    font.pixelSize: Style.fontSizeM || 14
                    color: Style.textColorSecondary || "#888888"
                }

                NButton {
                    text: pluginApi?.tr("widget.markAllRead", "Mark all as read") || "Mark all as read"
                    enabled: displayItems.length > 0
                    onClicked: markAllAsRead()
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Color.mOutlineVariant || "#333333"
            }

            // Content
            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                ListView {
                    model: displayItems
                    spacing: Style.marginS || 8

                    delegate: Rectangle {
                        required property var modelData
                        required property int index

                        width: ListView.view.width
                        height: itemLayout.implicitHeight + 16
                        color: isUnread ? (Style.fillColorTertiary || "#2A2A2A") : (Style.fillColorSecondary || "#1A1A1A")
                        radius: Style.radiusM || 8

                        readonly property bool isUnread: !readItems.includes(modelData.guid || modelData.link)

                        Rectangle {
                            visible: isUnread
                            width: 3
                            height: parent.height
                            color: Style.accentColor || "#4A9EFF"
                            radius: 1.5
                        }

                        ColumnLayout {
                            id: itemLayout
                            anchors.fill: parent
                            anchors.margins: 12
                            anchors.leftMargin: isUnread ? 18 : 12
                            spacing: 6

                            // Feed name
                            Text {
                                text: modelData.feedName || "Unknown Feed"
                                font.pixelSize: Style.fontSizeS || 11
                                font.bold: true
                                color: Style.accentColor || "#4A9EFF"
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }

                            // Title
                            Text {
                                text: modelData.title || "Untitled"
                                font.pixelSize: Style.fontSizeM || 14
                                font.bold: isUnread
                                color: Style.textColor || "#FFFFFF"
                                wrapMode: Text.Wrap
                                maximumLineCount: 2
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }

                            // Description
                            Text {
                                visible: modelData.description && modelData.description.length > 0
                                text: modelData.description || ""
                                font.pixelSize: Style.fontSizeS || 12
                                color: Style.textColorSecondary || "#AAAAAA"
                                wrapMode: Text.Wrap
                                maximumLineCount: 2
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }

                            // Date
                            Text {
                                text: formatDate(modelData.pubDate)
                                font.pixelSize: Style.fontSizeS || 11
                                color: Style.textColorSecondary || "#888888"
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (modelData.link) {
                                    Qt.openUrlExternally(modelData.link);
                                    if (markAsReadOnClick) {
                                        markAsRead(modelData.guid || modelData.link);
                                    }
                                }
                            }
                        }
                    }

                    Text {
                        visible: displayItems.length === 0
                        anchors.centerIn: parent
                        text: pluginApi?.tr("widget.noItems", "No items to display") || "No items to display"
                        font.pixelSize: Style.fontSizeM || 14
                        color: Style.textColorSecondary || "#888888"
                    }
                }
            }

            // Footer
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Style.borderColor || "#333333"
            }

            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: allItems.length + " total items"
                    font.pixelSize: Style.fontSizeS || 12
                    color: Style.textColorSecondary || "#888888"
                    Layout.fillWidth: true
                }
            }
        }
    }

    function formatDate(dateString) {
        const date = new Date(dateString);
        const now = new Date();
        const diffMs = now - date;
        const diffMins = Math.floor(diffMs / 60000);
        const diffHours = Math.floor(diffMs / 3600000);
        const diffDays = Math.floor(diffMs / 86400000);

        if (diffMins < 1) return pluginApi?.tr("widget.timeNow", "now") || "now";
        if (diffMins < 60) return (pluginApi?.tr("widget.timeMinutes", "%1min ago") || "%1min ago").replace("%1", diffMins);
        if (diffHours < 24) return (pluginApi?.tr("widget.timeHours", "%1h ago") || "%1h ago").replace("%1", diffHours);
        if (diffDays < 7) return (pluginApi?.tr("widget.timeDays", "%1d ago") || "%1d ago").replace("%1", diffDays);
        
        return date.toLocaleDateString();
    }
}
