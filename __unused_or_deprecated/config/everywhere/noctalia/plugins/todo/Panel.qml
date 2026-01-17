import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Commons
import qs.Services.UI
import qs.Widgets

Item {
  id: root

  property var pluginApi: null
  readonly property var geometryPlaceholder: panelContainer
  property real contentPreferredWidth: 700 * Style.uiScaleRatio
  property real contentPreferredHeight: 500 * Style.uiScaleRatio
  readonly property bool allowAttach: true
  anchors.fill: parent
  property ListModel todosModel: ListModel {}
  property ListModel filteredTodosModel: ListModel {}
  property bool showCompleted: false
  property var rawTodos: []

  Binding {
    target: root
    property: "rawTodos"
    value: pluginApi?.pluginSettings?.todos || []
  }

  Component.onCompleted: {
    if (pluginApi) {
      Logger.i("Todo", "Panel initialized");
      root.showCompleted = pluginApi?.pluginSettings?.showCompleted !== undefined
                           ? pluginApi.pluginSettings.showCompleted
                           : pluginApi?.manifest?.metadata?.defaultSettings?.showCompleted || false;
      loadTodos();
    }
  }

  function loadTodos() {
    todosModel.clear();
    filteredTodosModel.clear();

    var pluginTodos = root.rawTodos;

    for (var i = 0; i < pluginTodos.length; i++) {
      todosModel.append({
                          id: pluginTodos[i].id,
                          text: pluginTodos[i].text,
                          completed: pluginTodos[i].completed === true,
                          createdAt: pluginTodos[i].createdAt
                        });
    }

    for (var k = 0; k < pluginTodos.length; k++) {
      if (showCompleted || !pluginTodos[k].completed) {
        filteredTodosModel.append({
                                    id: pluginTodos[k].id,
                                    text: pluginTodos[k].text,
                                    completed: pluginTodos[k].completed === true,
                                    createdAt: pluginTodos[k].createdAt
                                  });
      }
    }
  }

  onPluginApiChanged: {
    if (pluginApi) {
      loadTodos();
    }
  }

  // Watch for changes in the todos array length or showCompleted setting
  property int previousTodosCount: -1

  Timer {
    id: settingsWatcher
    interval: 200
    running: !!pluginApi
    repeat: true
    onTriggered: {
    var newShowCompleted = pluginApi?.pluginSettings?.showCompleted !== undefined
                           ? pluginApi.pluginSettings.showCompleted
                           : pluginApi?.manifest?.metadata?.defaultSettings?.showCompleted || false;
      var currentTodos = pluginApi?.pluginSettings?.todos || [];
      var currentTodosCount = currentTodos.length;

      if (root.showCompleted !== newShowCompleted || root.previousTodosCount !== currentTodosCount) {
        root.showCompleted = newShowCompleted;
        root.previousTodosCount = currentTodosCount;
        loadTodos();
      }
    }
  }

  Rectangle {
    id: panelContainer
    anchors.fill: parent
    color: "transparent"

    ColumnLayout {
      anchors {
        fill: parent
        margins: Style.marginM
      }
      spacing: Style.marginL

      Rectangle {
        Layout.fillWidth: true
        Layout.fillHeight: true
        color: Color.mSurfaceVariant
        radius: Style.radiusL

        ColumnLayout {
          anchors.fill: parent
          anchors.margins: Style.marginM
          spacing: Style.marginM

          RowLayout {
            spacing: Style.marginM

            NIcon {
              icon: "checklist"
              pointSize: Style.fontSizeL
            }

            NText {
              text: pluginApi?.tr("panel.header.title")
              font.pointSize: Style.fontSizeL
              font.weight: Font.Medium
              color: Color.mOnSurface
            }

            Item {
              Layout.fillWidth: true
            }

            NButton {
              text: pluginApi?.tr("panel.header.clear_completed_button")
              onClicked: {
                if (pluginApi) {
                  var todos = pluginApi.pluginSettings.todos || [];

                  var activeTodos = todos.filter(todo => !todo.completed);

                  pluginApi.pluginSettings.todos = activeTodos;

                  pluginApi.pluginSettings.count = activeTodos.length;
                  pluginApi.pluginSettings.completedCount = 0;

                  pluginApi.saveSettings();

                  loadTodos();
                }
              }
            }
          }

          Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Color.mSurfaceVariant
            radius: Style.radiusM
            border.color: Color.mOutline
            border.width: 1

            ColumnLayout {
              anchors {
                fill: parent
                margins: Style.marginM
              }
              spacing: Style.marginM

              RowLayout {
                spacing: Style.marginS

                NTextInput {
                  id: newTodoInput
                  placeholderText: pluginApi?.tr("panel.add_todo.placeholder")
                  Layout.fillWidth: true
                  Keys.onReturnPressed: addTodo()
                }

                NButton {
                  text: pluginApi?.tr("panel.add_todo.add_button")
                  onClicked: addTodo()
                }
              }

              ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                ScrollBar.vertical.policy: ScrollBar.AsNeeded
                ScrollBar.vertical.visible: false
                ListView {
                  id: todoListView
                  model: root.filteredTodosModel
                  spacing: Style.marginS
                  boundsBehavior: Flickable.StopAtBounds
                  flickableDirection: Flickable.VerticalFlick

                  delegate: Item {
                    id: delegateItem
                    width: ListView.view.width
                    height: Style.baseWidgetSize

                    required property int index
                    required property var modelData

                    // Properties for drag functionality
                    property bool dragging: false
                    property int dragStartY: 0
                    property int dragStartIndex: -1
                    property int dragTargetIndex: -1
                    property int itemSpacing: Style.marginS

                    // Position binding for non-dragging state
                    y: {
                      if (delegateItem.dragging) {
                        return delegateItem.y;
                      }

                      // Check if any item is being dragged
                      var draggedIndex = -1;
                      var targetIndex = -1;
                      for (var i = 0; i < todoListView.count; i++) {
                        var item = todoListView.itemAtIndex(i);
                        if (item && item.dragging) {
                          draggedIndex = item.dragStartIndex;
                          targetIndex = item.dragTargetIndex;
                          break;
                        }
                      }

                      // If an item is being dragged, adjust positions
                      if (draggedIndex !== -1 && targetIndex !== -1 && draggedIndex !== targetIndex) {
                        var currentIndex = delegateItem.index;

                        if (draggedIndex < targetIndex) {
                          // Dragging down: shift items up between draggedIndex and targetIndex
                          if (currentIndex > draggedIndex && currentIndex <= targetIndex) {
                            return (currentIndex - 1) * (delegateItem.height + delegateItem.itemSpacing);
                          }
                        } else {
                          // Dragging up: shift items down between targetIndex and draggedIndex
                          if (currentIndex >= targetIndex && currentIndex < draggedIndex) {
                            return (currentIndex + 1) * (delegateItem.height + delegateItem.itemSpacing);
                          }
                        }
                      }

                      return delegateItem.index * (delegateItem.height + delegateItem.itemSpacing);
                    }

                    // Behavior for smooth animation when not dragging
                    Behavior on y {
                      enabled: !delegateItem.dragging
                      NumberAnimation {
                        duration: Style.animationNormal
                        easing.type: Easing.OutQuad
                      }
                    }

                    // The actual todo item rectangle
                    Rectangle {
                      anchors.fill: parent
                      color: Color.mSurface
                      radius: Style.radiusS

                      RowLayout {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: Style.marginM
                        anchors.rightMargin: Style.marginM
                        spacing: Style.marginS

                        // Drag handle
                        Rectangle {
                          id: dragHandle

                          Layout.preferredWidth: Style.baseWidgetSize * 0.7
                          Layout.preferredHeight: Style.baseWidgetSize * 0.7
                          radius: Style.iRadiusXS
                          color: dragHandleMouseArea.containsMouse ? Color.mSurfaceVariant : "transparent"

                          Behavior on color {
                            ColorAnimation {
                              duration: Style.animationFast
                            }
                          }

                          ColumnLayout {
                            anchors.centerIn: parent
                            spacing: Style.marginS

                            Repeater {
                              model: 3
                              Rectangle {
                                Layout.preferredWidth: Style.baseWidgetSize * 0.7 * 0.4
                                Layout.preferredHeight: 2
                                radius: 1
                                color: Color.mOutline
                              }
                            }
                          }

                          MouseArea {
                            id: dragHandleMouseArea

                            anchors.fill: parent
                            cursorShape: Qt.SizeVerCursor
                            hoverEnabled: true
                            preventStealing: false
                            z: 1000

                            onPressed: mouse => {
                                         delegateItem.dragStartIndex = delegateItem.index;
                                         delegateItem.dragTargetIndex = delegateItem.index;
                                         delegateItem.dragStartY = delegateItem.y;
                                         delegateItem.dragging = true;
                                         delegateItem.z = 999;

                                         // Signal that interaction started (prevents panel close)
                                         preventStealing = true;
                                       }

                            onPositionChanged: mouse => {
                                                 if (delegateItem.dragging) {
                                                   var dy = mouse.y - dragHandle.height / 2;
                                                   var newY = delegateItem.y + dy;

                                                   // Constrain within bounds
                                                   newY = Math.max(0, Math.min(newY, todoListView.contentHeight - delegateItem.height));
                                                   delegateItem.y = newY;

                                                   // Calculate target index (but don't apply yet)
                                                   var targetIndex = Math.floor((newY + delegateItem.height / 2) / (delegateItem.height + delegateItem.itemSpacing));
                                                   targetIndex = Math.max(0, Math.min(targetIndex, todoListView.count - 1));

                                                   delegateItem.dragTargetIndex = targetIndex;
                                                 }
                                               }

                            onReleased: {
                              // Apply the model change now that drag is complete
                              if (delegateItem.dragStartIndex !== -1 && delegateItem.dragTargetIndex !== -1 && delegateItem.dragStartIndex !== delegateItem.dragTargetIndex) {
                                moveTodoItem(delegateItem.dragStartIndex, delegateItem.dragTargetIndex);
                              }

                              delegateItem.dragging = false;
                              delegateItem.dragStartIndex = -1;
                              delegateItem.dragTargetIndex = -1;
                              delegateItem.z = 0;

                              // Reset interaction prevention
                              preventStealing = false;
                            }

                            onCanceled: {
                              // Handle cancel (e.g., ESC key pressed during drag)
                              delegateItem.dragging = false;
                              delegateItem.dragStartIndex = -1;
                              delegateItem.dragTargetIndex = -1;
                              delegateItem.z = 0;

                              // Reset interaction prevention
                              preventStealing = false;
                            }
                          }
                        }

                        // Checkbox
                        Item {
                          Layout.preferredWidth: Style.baseWidgetSize * 0.7
                          Layout.preferredHeight: Style.baseWidgetSize * 0.7

                          Rectangle {
                            id: box

                            anchors.fill: parent
                            radius: Style.iRadiusXS
                            color: modelData.completed ? Color.mPrimary : Color.mSurface
                            border.color: Color.mOutline
                            border.width: Style.borderS

                            Behavior on color {
                              ColorAnimation {
                                duration: Style.animationFast
                              }
                            }

                            NIcon {
                              visible: modelData.completed
                              anchors.centerIn: parent
                              anchors.horizontalCenterOffset: -1
                              icon: "check"
                              color: Color.mOnPrimary
                              pointSize: Math.max(Style.fontSizeXS, Style.baseWidgetSize * 0.7 * 0.5)
                            }

                            MouseArea {
                              anchors.fill: parent
                              cursorShape: Qt.PointingHandCursor
                              onClicked: {
                                if (pluginApi) {
                                  var todos = pluginApi.pluginSettings.todos || [];

                                  for (var i = 0; i < todos.length; i++) {
                                    if (todos[i].id === modelData.id) {
                                      todos[i].completed = !modelData.completed;
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
                                  loadTodos();
                                }
                              }
                            }
                          }
                        }

                        // Text
                        NText {
                          text: modelData.text
                          color: modelData.completed ? Color.mOnSurfaceVariant : Color.mOnSurface
                          font.strikeout: modelData.completed
                          verticalAlignment: Text.AlignVCenter
                          elide: Text.ElideRight
                          Layout.fillWidth: true
                        }

                        // Edit button
                        Item {
                          id: editButtonContainer
                          implicitWidth: Style.baseWidgetSize * 0.6
                          implicitHeight: Style.baseWidgetSize * 0.6

                          NIcon {
                            id: editButtonIcon
                            anchors.centerIn: parent
                            icon: "pencil"
                            pointSize: Style.fontSizeS
                            color: Color.mOnSurfaceVariant
                            opacity: 0.3

                            MouseArea {
                              id: editMouseArea
                              anchors.fill: parent
                              hoverEnabled: true
                              cursorShape: Qt.PointingHandCursor
                              onClicked: {
                                // Set the current todo for editing
                                currentTodoId = modelData.id;
                                currentTodoText = modelData.text;
                                editDialog.open();
                              }
                            }

                            ToolTip {
                              id: editToolTip
                              text: pluginApi?.tr("panel.todo_item.edit_button_tooltip") || "Edit"
                              delay: 1000
                              parent: editButtonIcon
                              visible: editMouseArea.containsMouse

                              contentItem: NText {
                                text: editToolTip.text
                                color: Color.mOnPrimary
                                font.pointSize: Style.fontSizeXS
                              }

                              background: Rectangle {
                                color: Color.mPrimary
                                radius: Style.iRadiusS
                                border.color: Qt.rgba(0, 0, 0, 0.2)
                                border.width: 1
                              }
                            }

                            states: [
                              State {
                                name: "hovered"
                                when: editMouseArea.containsMouse
                                PropertyChanges {
                                  target: editButtonIcon
                                  opacity: 1.0
                                  color: Color.mPrimary
                                }
                              }
                            ]

                            transitions: [
                              Transition {
                                from: "*"; to: "hovered"
                                NumberAnimation { properties: "opacity"; duration: 150 }
                              },
                              Transition {
                                from: "hovered"; to: "*"
                                NumberAnimation { properties: "opacity"; duration: 150 }
                              }
                            ]
                          }
                        }

                        // Delete button
                        Item {
                          id: deleteButtonContainer
                          implicitWidth: Style.baseWidgetSize * 0.6
                          implicitHeight: Style.baseWidgetSize * 0.6

                          NIcon {
                            id: deleteButtonIcon
                            anchors.centerIn: parent
                            icon: "x"
                            pointSize: Style.fontSizeS
                            color: Color.mOnSurfaceVariant
                            opacity: 0.3

                            MouseArea {
                              id: mouseArea
                              anchors.fill: parent
                              hoverEnabled: true
                              cursorShape: Qt.PointingHandCursor
                              onClicked: {
                                // Directly modify the todos list through pluginApi
                                if (pluginApi) {
                                  var todos = pluginApi.pluginSettings.todos || [];
                                  var indexToRemove = -1;

                                  for (var i = 0; i < todos.length; i++) {
                                    if (todos[i].id === modelData.id) {
                                      indexToRemove = i;
                                      break;
                                    }
                                  }

                                  if (indexToRemove !== -1) {
                                    todos.splice(indexToRemove, 1);

                                    pluginApi.pluginSettings.todos = todos;
                                    pluginApi.pluginSettings.count = todos.length;

                                    // Recalculate completed count after removal
                                    var completedCount = 0;
                                    for (var j = 0; j < todos.length; j++) {
                                      if (todos[j].completed) {
                                        completedCount++;
                                      }
                                    }
                                    pluginApi.pluginSettings.completedCount = completedCount;

                                    pluginApi.saveSettings();
                                    loadTodos();
                                  } else {
                                    Logger.e("Todo", "Todo with ID " + modelData.id + " not found for deletion");
                                  }
                                } else {
                                  Logger.e("Todo", "pluginApi is null, cannot delete todo");
                                }
                              }
                            }

                            ToolTip {
                              id: deleteToolTip
                              text: pluginApi?.tr("panel.todo_item.delete_button_tooltip") || "Delete"
                              delay: 1000
                              parent: deleteButtonIcon
                              visible: mouseArea.containsMouse

                              contentItem: NText {
                                text: deleteToolTip.text
                                color: Color.mOnError
                                font.pointSize: Style.fontSizeXS
                              }

                              background: Rectangle {
                                color: Color.mError
                                radius: Style.iRadiusS
                                border.color: Qt.rgba(0, 0, 0, 0.2)
                                border.width: 1
                              }
                            }

                            states: [
                              State {
                                name: "hovered"
                                when: mouseArea.containsMouse
                                PropertyChanges {
                                  target: deleteButtonIcon
                                  opacity: 1.0
                                  color: Color.mError
                                }
                              }
                            ]

                            transitions: [
                              Transition {
                                from: "*"; to: "hovered"
                                NumberAnimation { properties: "opacity"; duration: 150 }
                              },
                              Transition {
                                from: "hovered"; to: "*"
                                NumberAnimation { properties: "opacity"; duration: 150 }
                              }
                            ]
                          }
                        }
                      }
                    }
                  }

                  highlightRangeMode: ListView.NoHighlightRange
                  preferredHighlightBegin: 0
                  preferredHighlightEnd: 0

                  header: Item {
                    width: ListView.view.width
                    height: root.todosModel.count === 0 ? contentText.implicitHeight + Style.marginL * 2 : 0

                    NText {
                      id: contentText
                      anchors.centerIn: parent
                      text: root.todosModel.count === 0 ? pluginApi?.tr("panel.empty_state.message") : ""
                      color: Color.mOnSurfaceVariant
                      font.pointSize: Style.fontSizeM
                      font.weight: Font.Normal
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  // Properties for edit dialog
  property var currentTodoId: null
  property string currentTodoText: ""

  // Edit Dialog
  Popup {
    id: editDialog
    modal: true
    dim: true
    anchors.centerIn: Overlay.overlay
    width: 400 * Style.uiScaleRatio
    height: 200 * Style.uiScaleRatio
    padding: Style.marginL
    background: Rectangle {
      color: Color.mSurface
      border.color: Color.mOutline
      border.width: 1
      radius: Style.radiusL
    }

    ColumnLayout {
      anchors.fill: parent
      spacing: Style.marginM

      NText {
        text: pluginApi?.tr("panel.edit_todo.title") || "Edit Todo"
        font.pointSize: Style.fontSizeL
        font.weight: Font.Bold
        color: Color.mOnSurface
        Layout.fillWidth: true
        horizontalAlignment: Text.AlignHCenter
      }

      NTextInput {
        id: editTodoInput
        text: root.currentTodoText
        placeholderText: pluginApi?.tr("panel.edit_todo.placeholder") || "Enter todo text"
        Layout.fillWidth: true
        onTextChanged: root.currentTodoText = text
      }

      RowLayout {
        Layout.alignment: Qt.AlignHCenter
        spacing: Style.marginM

        NButton {
          text: pluginApi?.tr("panel.edit_todo.cancel_button") || "Cancel"
          onClicked: {
            editDialog.close();
          }
        }

        NButton {
          text: pluginApi?.tr("panel.edit_todo.save_button") || "Save"
          backgroundColor: Color.mPrimary
          textColor: Color.mOnPrimary
          onClicked: {
            if (pluginApi && root.currentTodoId !== null && root.currentTodoText.trim() !== "") {
              var todos = pluginApi.pluginSettings.todos || [];

              for (var i = 0; i < todos.length; i++) {
                if (todos[i].id === root.currentTodoId) {
                  todos[i].text = root.currentTodoText.trim();
                  break;
                }
              }

              pluginApi.pluginSettings.todos = todos;
              pluginApi.saveSettings();
              loadTodos();
              editDialog.close();
            }
          }
        }
      }
    }

    onOpened: {
      editTodoInput.forceActiveFocus();
      editTodoInput.text = root.currentTodoText;
    }

    onClosed: {
      root.currentTodoId = null;
      root.currentTodoText = "";
    }
  }

  function addTodo() {
    if (newTodoInput.text.trim() !== "") {
      if (pluginApi) {
        var todos = pluginApi.pluginSettings.todos || [];

        var newTodo = {
          id: Date.now() // Use timestamp as simple ID
              ,
          text: newTodoInput.text.trim(),
          completed: false,
          createdAt: new Date().toISOString()
        };

        todos.push(newTodo);

        pluginApi.pluginSettings.todos = todos;

        pluginApi.pluginSettings.count = todos.length;

        pluginApi.saveSettings();

        newTodoInput.text = "";
        loadTodos(); // Reload todos to update view
      }
    }
  }

  function moveTodoItem(fromIndex, toIndex) {
    if (fromIndex === toIndex)
      return;
    if (fromIndex < 0 || fromIndex >= root.rawTodos.length)
      return;
    if (toIndex < 0 || toIndex >= root.rawTodos.length)
      return;

    // Create a new array with item moved
    var newTodos = root.rawTodos.slice();
    var item = newTodos.splice(fromIndex, 1)[0];
    newTodos.splice(toIndex, 0, item);

    // Update the plugin settings
    if (pluginApi) {
      pluginApi.pluginSettings.todos = newTodos;
      pluginApi.saveSettings();
      loadTodos(); // Reload to update the view
    }
  }
}
