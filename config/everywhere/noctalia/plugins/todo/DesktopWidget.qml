import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Commons
import qs.Modules.DesktopWidgets
import qs.Widgets

DraggableDesktopWidget {
  id: root

  property var pluginApi: null
  property bool expanded: false
  property bool showCompleted: pluginApi?.pluginSettings?.showCompleted !== undefined ? pluginApi.pluginSettings.showCompleted : pluginApi?.manifest?.metadata?.defaultSettings?.showCompleted
  property ListModel filteredTodosModel: ListModel {}

  showBackground: (pluginApi && pluginApi.pluginSettings ? (pluginApi.pluginSettings.showBackground !== undefined ? pluginApi.pluginSettings.showBackground : pluginApi?.manifest?.metadata?.defaultSettings?.showBackground) : pluginApi?.manifest?.metadata?.defaultSettings?.showBackground)

  readonly property color todoBg: showBackground ? Qt.rgba(0, 0, 0, 0.2) : "transparent"
  readonly property color itemBg: showBackground ? Color.mSurface : "transparent"
  readonly property color completedItemBg: showBackground ? Color.mSurfaceVariant : "transparent"

  // Scaled dimensions
  readonly property int scaledMarginM: Math.round(Style.marginM * widgetScale)
  readonly property int scaledMarginS: Math.round(Style.marginS * widgetScale)
  readonly property int scaledMarginL: Math.round(Style.marginL * widgetScale)
  readonly property int scaledBaseWidgetSize: Math.round(Style.baseWidgetSize * widgetScale)
  readonly property int scaledFontSizeL: Math.round(Style.fontSizeL * widgetScale)
  readonly property int scaledFontSizeM: Math.round(Style.fontSizeM * widgetScale)
  readonly property int scaledFontSizeS: Math.round(Style.fontSizeS * widgetScale)
  readonly property int scaledRadiusM: Math.round(Style.radiusM * widgetScale)
  readonly property int scaledRadiusS: Math.round(Style.radiusS * widgetScale)

  implicitWidth: Math.round(300 * widgetScale)
  implicitHeight: {
    var headerHeight = scaledBaseWidgetSize + scaledMarginL * 2;
    if (!expanded)
      return headerHeight;

    var todosCount = root.filteredTodosModel.count;
    var contentHeight = (todosCount === 0) ? scaledBaseWidgetSize : (scaledBaseWidgetSize * todosCount + scaledMarginS * (todosCount - 1));

    var totalHeight = contentHeight + scaledMarginM * 2 + headerHeight;
    return Math.min(totalHeight, headerHeight + Math.round(400 * widgetScale)); // Max 400px of content (scaled)
  }

  function getCurrentTodos() {
    return pluginApi?.pluginSettings?.todos || [];
  }

  function getCurrentShowCompleted() {
    return pluginApi?.pluginSettings?.showCompleted !== undefined ? pluginApi.pluginSettings.showCompleted : pluginApi?.manifest?.metadata?.defaultSettings?.showCompleted || false;
  }

  function updateFilteredTodos() {
    if (!pluginApi)
      return;

    filteredTodosModel.clear();

    var pluginTodos = getCurrentTodos();
    var currentShowCompleted = getCurrentShowCompleted();
    var filtered = pluginTodos;

    if (!currentShowCompleted) {
      filtered = pluginTodos.filter(function (todo) {
        return !todo.completed;
      });
    }

    for (var i = 0; i < filtered.length; i++) {
      filteredTodosModel.append({
                                  id: filtered[i].id,
                                  text: filtered[i].text,
                                  completed: filtered[i].completed
                                });
    }
  }

  Timer {
    id: updateTimer
    interval: 200
    running: !!pluginApi
    repeat: true
    onTriggered: {
      updateFilteredTodos();
    }
  }

  onPluginApiChanged: {
    if (pluginApi) {
      root.showCompleted = getCurrentShowCompleted();
      updateFilteredTodos();
    }
  }

  Component.onCompleted: {
    if (pluginApi) {
      updateFilteredTodos();
    }
  }

  ColumnLayout {
    anchors.fill: parent
    anchors.margins: scaledMarginM
    spacing: scaledMarginS

    Item {
      Layout.fillWidth: true
      height: scaledBaseWidgetSize

      MouseArea {
        anchors.fill: parent
        onClicked: {
          root.expanded = !root.expanded;
        }
      }

      RowLayout {
        anchors.fill: parent
        spacing: scaledMarginS

        NIcon {
          icon: "checklist"
          pointSize: scaledFontSizeL
        }

        NText {
          text: pluginApi?.tr("desktop_widget.header_title")
          font.pointSize: scaledFontSizeL
          font.weight: Font.Medium
        }

        Item {
          Layout.fillWidth: true
        }

        NText {
          text: {
            var todos = pluginApi?.pluginSettings?.todos || [];
            var activeTodos = todos.filter(function (todo) {
              return !todo.completed;
            }).length;

            var text = pluginApi?.tr("desktop_widget.items_count");
            return text.replace("{active}", activeTodos).replace("{total}", todos.length);
          }
          color: Color.mOnSurfaceVariant
          font.pointSize: scaledFontSizeS
        }

        NIcon {
          icon: root.expanded ? "chevron-up" : "chevron-down"
          pointSize: scaledFontSizeM
          color: Color.mOnSurfaceVariant
        }
      }
    }

    Item {
      Layout.fillWidth: true
      Layout.fillHeight: true
      visible: expanded

      // Background with border - fills entire available space
      Rectangle {
        id: backgroundRect
        anchors.fill: parent
        color: root.todoBg
        radius: scaledRadiusM
        border.color: showBackground ? Color.mOutline : "transparent"
        border.width: showBackground ? 1 : 0
      }

      // Inner container that is fully inset from the border area
      Item {
        id: innerContentArea
        anchors.fill: parent
        anchors.margins: showBackground ? 2 : 0  // Use 2px margin to ensure we're clear of 1px border

        // Scrollable area for the todo items
        Flickable {
          id: todoFlickable
          anchors.fill: parent
          topMargin: scaledMarginL
          bottomMargin: scaledMarginL
          leftMargin: scaledMarginS
          rightMargin: scaledMarginM
          contentWidth: width - (leftMargin + rightMargin)  // Account for margins in content width
          contentHeight: columnLayout.implicitHeight
          flickableDirection: Flickable.VerticalFlick
          clip: true  // Critical: ensures content doesn't render outside bounds
          boundsBehavior: Flickable.StopAtBounds  // Completely stop at bounds, no overscroll
          interactive: true
          // Increase pressDelay to give child TapHandler priority for short taps
          pressDelay: 150  // Longer delay to distinguish between tap and flick

          Column {
            id: columnLayout
            width: parent.width
            spacing: scaledMarginS

            Repeater {
              model: root.filteredTodosModel

              delegate: Item {
                width: parent.width
                height: scaledBaseWidgetSize

                Rectangle {
                  anchors.fill: parent
                  anchors.margins: 0
                  color: model.completed ? root.completedItemBg : root.itemBg
                  radius: scaledRadiusS

                  Item {
                    anchors.fill: parent
                    anchors.margins: scaledMarginM

                    // Custom checkbox implementation with TapHandler
                    Item {
                      id: customCheckboxContainer
                      width: scaledBaseWidgetSize * 0.7  // Slightly larger touch area
                      height: scaledBaseWidgetSize * 0.7
                      anchors.left: parent.left
                      anchors.verticalCenter: parent.verticalCenter

                      Rectangle {
                        id: customCheckbox
                        width: scaledBaseWidgetSize * 0.5
                        height: scaledBaseWidgetSize * 0.5
                        radius: Style.iRadiusXS
                        color: showBackground ? (model.completed ? Color.mPrimary : Color.mSurface) : "transparent"
                        border.color: Color.mOutline
                        border.width: Style.borderS
                        anchors.centerIn: parent

                        NIcon {
                          visible: model.completed
                          anchors.centerIn: parent
                          anchors.horizontalCenterOffset: 0  // Center the checkmark properly
                          icon: "check"
                          color: showBackground ? Color.mOnPrimary : Color.mPrimary
                          pointSize: Math.max(Style.fontSizeXS, width * 0.5)
                        }

                        // MouseArea for the checkbox
                        MouseArea {
                          anchors.fill: parent
                          hoverEnabled: false  // Disable hover to prevent cursor flickering

                          onClicked: {
                            if (pluginApi) {
                              var todos = pluginApi.pluginSettings.todos || [];

                              for (var i = 0; i < todos.length; i++) {
                                if (todos[i].id === model.id) {
                                  todos[i].completed = !todos[i].completed;  // Toggle the completed status
                                  break;
                                }
                              }

                              pluginApi.pluginSettings.todos = todos;

                              var completedCount = 0;
                              for (var j = 0; j < todos.length; j++) {
                                if (todos[j].completed) {
                                  completedCount++;
                                }
                              }
                              pluginApi.pluginSettings.completedCount = completedCount;

                              pluginApi.saveSettings();
                              updateFilteredTodos(); // Refresh the display
                            }
                          }
                        }
                      }
                    }

                    // Text for the todo item
                    NText {
                      text: model.text
                      color: model.completed ? Color.mOnSurfaceVariant : Color.mOnSurface
                      font.strikeout: model.completed
                      elide: Text.ElideRight
                      anchors.left: customCheckboxContainer.right
                      anchors.leftMargin: scaledMarginS
                      anchors.right: parent.right
                      anchors.verticalCenter: parent.verticalCenter
                      font.pointSize: scaledFontSizeS
                    }
                  }
                }
              }
            }
          }
        }

        // Empty state overlay
        Item {
          anchors.fill: parent
          anchors.margins: scaledMarginS
          visible: root.filteredTodosModel.count === 0

          NText {
            anchors.centerIn: parent
            text: pluginApi?.tr("desktop_widget.empty_state")
            color: Color.mOnSurfaceVariant
            font.pointSize: scaledFontSizeM
            font.weight: Font.Normal
          }
        }
      }
    }
  }
}
