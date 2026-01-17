import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Widgets

ColumnLayout {
  id: root

  property var pluginApi: null

  property bool valueShowCompleted: pluginApi?.pluginSettings?.showCompleted !== undefined
                                    ? pluginApi.pluginSettings.showCompleted
                                    : pluginApi?.manifest?.metadata?.defaultSettings?.showCompleted

  property bool valueShowBackground: pluginApi?.pluginSettings?.showBackground !== undefined
                                    ? pluginApi.pluginSettings.showBackground
                                    : pluginApi?.manifest?.metadata?.defaultSettings?.showBackground

  spacing: Style.marginM

  Component.onCompleted: {
    Logger.i("Todo", "Settings UI loaded");
  }

  NToggle {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.show_completed.label")
    description: pluginApi?.tr("settings.show_completed.description")
    checked: root.valueShowCompleted
    onToggled: function (checked) {
      root.valueShowCompleted = checked;
    }
  }

   NToggle {
      Layout.fillWidth: true
      label: pluginApi?.tr("settings.background_color.label")
      description: pluginApi?.tr("settings.background_color.description")
      checked: root.valueShowBackground
      onToggled: function (checked) {
        root.valueShowBackground = checked;
      }
    }

  function saveSettings() {
    if (!pluginApi) {
      Logger.e("Todo", "Cannot save settings: pluginApi is null");
      return;
    }

    pluginApi.pluginSettings.showCompleted = root.valueShowCompleted;
    pluginApi.pluginSettings.showBackground = root.valueShowBackground;
    pluginApi.saveSettings();

    Logger.i("Todo", "Settings saved successfully");
  }
}
