import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Commons
import qs.Widgets

Rectangle {
  id: root

  property var pluginApi: null

  property ShellScreen screen
  property string widgetId: ""
  property string section: ""

  implicitWidth: barIsVertical ? Style.capsuleHeight : contentRow.implicitWidth + Style.marginM * 2
  implicitHeight: Style.capsuleHeight


  function getIntValue(value, defaultValue) {
    return (typeof value === 'number') ? Math.floor(value) : defaultValue;
  }

  readonly property int todoCount: getIntValue(pluginApi?.pluginSettings?.count, getIntValue(pluginApi?.manifest?.metadata?.defaultSettings?.count, 0))
  readonly property int completedCount: getIntValue(pluginApi?.pluginSettings?.completedCount, getIntValue(pluginApi?.manifest?.metadata?.defaultSettings?.completedCount, 0))
  readonly property int activeCount: todoCount - completedCount

  readonly property string barPosition: Settings.data.bar.position || "top"
  readonly property bool barIsVertical: barPosition === "left" || barPosition === "right"

  color: Style.capsuleColor
  radius: Style.radiusL

  RowLayout {
    id: contentRow
    anchors.centerIn: parent
    spacing: Style.marginS

    NIcon {
      icon: "checklist"
      applyUiScale: false
      color: mouseArea.containsMouse ? Color.mOnHover : Color.mOnSurface
    }

    NText {
      visible: !barIsVertical
      text: {
        var count = activeCount;
        var key = count === 1 ? "bar_widget.todo_count_singular" : "bar_widget.todo_count_plural";
        var text = pluginApi?.tr(key) || (count + " todo" + (count !== 1 ? 's' : ''));
        return text.replace("{count}", count);
      }
      color: mouseArea.containsMouse ? Color.mOnHover : Color.mOnSurface
      pointSize: Style.fontSizeS
      font.weight: Font.Medium
    }
  }

  MouseArea {
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor

    onEntered: {
      root.color = Color.mHover;
    }

    onExited: {
      root.color = Style.capsuleColor;
    }

    onClicked: {
      if (pluginApi) {
        Logger.i("Todo", "Opening Todo panel");
        pluginApi.openPanel(root.screen);
      }
    }
  }
}
