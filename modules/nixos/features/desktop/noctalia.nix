###############################################################################
#
# Global config for Noctalia, a quickshell integration to pair with niri.
#
# User related preferences are in their config under /users/...
#
# Resources:
# - https://docs.noctalia.dev/getting-started/nixos/
#
###############################################################################

{ inputs, self, ... }:
{
  # flake.nixosModules.noctalia = { lib, config, pkgs, ...}: let
  #   cfg = config.nouveauxParadigmes;
  # in
  # {
  #   imports = [ inputs.noctalia.nixosModules.default ];
    
  #   config = {
  #     services.noctalia-shell.enable = true; # Run as a systemd service
  #   };
  # };

  flake.homeModules.noctalia = { lib, config, pkgs, ... }: let
    officialNoctaliaPlugins = "https://github.com/noctalia-dev/noctalia-plugins";
  in
  {
    imports = [ inputs.noctalia.homeModules.default ];

    config = {
      programs.noctalia-shell = {
        enable         = true;
        systemd.enable = true;

        plugins = {
          sources = [
            { enabled = true;
              name    = "Official Noctalia Plugins";
              url     = officialNoctaliaPlugins; }
          ];

          states = lib.listToAttrs ( map ( plugin: {
            name  = plugin;
            value = {
              enabled   = true;
              sourceUrl = officialNoctaliaPlugins;
            };
          } ) [ "privacy-indicator" "screen-recorder" "simple-notes" "todo" ] );

          version = 1;
        };

        settings = {
          settingsVersion = 1; # @todo What is this?

          appLauncher = {
            autoPasteClipboard        = false;
            customLaunchPrefix        = "";
            customLaunchPrefixEnabled = false;
            enableClipboardHistory    = true;
            enableClipPreview         = false;
            iconMode                  = "tabler";
            ignoreMouseInput          = false;
            pinnedExecs               = [];
            position                  = "center";
            screenshotAnnotationTool  = "";
            showCategories            = true;
            showIconBackground        = false;
            sortByMostUsed            = true;
            terminalCommand           = "ghostty -e";
            useApp2Unit               = false;
            viewMode                  = "list";
          };

          audio = {
            cavaFrameRate   = 30;
            externalMixer   = "pwvucontrol";
            mprisBlacklist  = [];
            preferredPlayer = "";
            visualizerType  = "linear";
            volumeOverdrive = false;
            volumeStep      = 5;
          };

          bar = {
            backgroundOpacity  = 0;
            capsuleOpacity     = 1;
            density            = "comfortable";
            exclusive          = true;
            floating           = true;
            hideOnOverview     = true;
            marginHorizontal   = 0.25;
            marginVertical     = 0;
            monitors           = [];
            outerCorners       = false;
            position           = "bottom";
            showCapsule        = false;
            showOutline        = false;
            useSeparateOpacity = true;
            widgets = {
              center = [];
              left   = [
                { id = "Workspace";

                  characterCount             = 10;
                  colorizeIcons              = false;
                  enableScrollWheel          = true;
                  followFocusedScreen        = false;
                  groupedBorderOpacity       = 1;
                  hideUnoccupied             = true;
                  iconScale                  = 1;
                  labelMode                  = "name";
                  showApplications           = false;
                  showLabelsOnlyWhenOccupied = true;
                  unfocusedIconsOpacity      = 1; }
              ];
              right = [
                { id = "MediaMini";

                  compactMode      = false;
                  hideMode         = "hidden";
                  hideWhenIdle     = true;
                  maxWidth         = 300;
                  scrollingMode    = "hover";
                  showAlbumArt     = false;
                  showArtistFirst  = true;
                  showProgressRing = true;
                  showVisualizer   = true;
                  useFixedWidth    = false;
                  visualizerType   = "linear"; }

                { id = "plugin:privacy-indicator";

                  defaultSettings = {
                    hideInactive  = true;
                    iconSpacing   = 4;
                    removeMargins = false;
                  }; }

                { id = "SystemMonitor";

                  compactMode         = false;
                  diskPath            = "/";
                  showCpuTemp         = false;
                  showCpuUsage        = false;
                  showDiskUsage       = false;
                  showGpuTemp         = false;
                  showLoadAverage     = false;
                  showMemoryAsPercent = false;
                  showMemoryUsage     = false;
                  showNetworkStats    = true;
                  useMonospaceFont    = true;
                  usePrimaryColor     = false; }

                { id = "Network";
                  displayMode = "alwaysShow"; }

                { id = "Bluetooth";
                  displayMode = "onhover"; }

                { id = "Battery";

                  displayMode             = "alwaysShow";
                  hideIfNotDetected       = true;
                  showNoctaliaPerformance = true;
                  showPowerProfiles       = true;
                  warningThreshold        = 15; }

                { id = "plugin:todo";

                  defaultSettings = {
                    completedCount = 0;
                    count          = 0;
                    showBackground = true;
                    showCompleted  = true;
                  }; }

                { id = "plugin:simple-notes";

                  defaultSettings = {
                    notes          = [];
                    showCountInBar = true;
                  }; }

                { id = "Clock";

                  customFont       = "";
                  formatHorizontal = "HH:mm:ss";
                  formatVertical   = "HH mm";
                  tooltipFormat    = "dddd yyyy-MM-dd HH:mm:ss";
                  useCustomFont    = false;
                  usePrimaryColor  = false; }
              ];
            };
          };

          brightness = {
            brightnessStep   = 5;
            enableDdcSupport = false;
            enforceMinimum   = true;
          };

          calendar = {
            cards = [
              { id      = "calendar-header-card";
                enabled = true; }

              { id      = "calendar-month-card";
                enabled = true; }

              { id      = "timer-card";
                enabled = true; }

              { id      = "weather-card";
                enabled = false; }
            ];
          };

          colorSchemes = {
            darkMode           = true;
            manualSunrise      = "08:00";
            manualSunset       = "19:30";
            matugenSchemeType  = "scheme-tonal-spot";
            predefinedScheme   = "Tokyo Night";
            schedulingMode     = "off";
            useWallpaperColors = true;
          };

          controlCenter = {
            cards     = [
              { id      = "profile-card";
                enabled = true; }

              { id      = "shortcuts-card";
                enabled = true; }

              { id      = "audio-card";
                enabled = true; }

              { id = "brightness-card";
                enabled = false; }

              { id = "weather-card";
                enabled = true; }

              { id      = "media-sysmon-card";
                enabled = true; }
            ];
            diskPath  = "/";
            position  = "center";
            shortcuts = {
              left = [
                { id = "WiFi"; }
                { id = "Bluetooth"; }
                { id = "KeepAwake"; }
                { id = "PowerProfile"; }
              ];
              right = [
                { id = "Notifications"; }
                { id = "NightLight"; }
                { id = "WallpaperSelector"; }
                { id = "plugin:screen-recorder";

                  defaultSettings = {
                    audioCodec      = "opus";
                    audioSource     = "default_output";
                    colorRange      = "limited";
                    copyToClipboard = false;
                    directory       = "~/Data/Screenshots"; # @todo Find how to write it for all users at once here
                    filenamePattern = "yyyyMMdd_HHmmss-screen_recording";
                    frameRate       = 60;
                    quality         = "very_high";
                    resolution      = "original";
                    showCursor      = true;
                    videoCodec      = "h264";
                    videoSource     = "portal";
                  }; }
              ];
            };
          };

          desktopWidgets = {
            enabled        = false; # true;
            gridSnap       = true;
            monitorWidgets = [
              {
                name    = "eDP-1";
                widgets = [
                  # { id = "Clock";

                  #   clockStyle      = "binary";
                  #   customFont      = "";
                  #   format          = "HH:mm";
                  #   roundedCorners  = false;
                  #   scale           = 7;
                  #   showBackground  = false;
                  #   useCustomFont   = false;
                  #   usePrimaryColor = false;
                  #   x               = 1600;
                  #   y               = 750; }
                ];
              }
            ];
          };

          dock = {
            animationSpeed     = 1;
            backgroundOpacity  = 1;
            colorizeIcons      = false;
            deadOpacity        = 0.6;
            displayMode        = "auto_hide";
            enabled            = false;
            floatingRatio      = 1;
            inactiveIndicators = false;
            monitors           = [];
            onlySameOutput     = true;
            pinnedApps         = [];
            pinnedStatic       = false;
            position           = "bottom";
            size               = 1;
          };

          general = {
            allowPanelsOnScreenWithoutBar  = true;
            animationDisabled              = false;
            animationSpeed                 = 1;
            avatarImage                    = "~/.face"; # @todo Find how to write it so I don't have to set it for every user
            boxRadiusRatio                 = 1;
            compactLockScreen              = false;
            dimmerOpacity                  = 0.3;
            enableShadows                  = false;
            forceBlackScreenCorners        = false;
            iRadiusRatio                   = 1;
            language                       = "";
            lockOnSuspend                  = true;
            radiusRatio                    = 0.2;
            scaleRatio                     = 1;
            screenRadiusRatio              = 1;
            shadowDirection                = "bottom_right";
            shadowOffsetX                  = 2;
            shadowOffsetY                  = 3;
            showChangelogOnStartup         = true;
            showHibernateOnLockScreen      = true;
            showScreenCorners              = false;
            showSessionButtonsOnLockScreen = true;
            telemetryEnabled               = false;
          };

          hooks = {
            darkModeChange          = "";
            enabled                 = false;
            performanceModeEnabled  = "";
            performanceModeDisabled = "";
            screenLock              = "";
            screenUnlock            = "";
            wallpaperChange         = "";
          };

          location = {
            analogClockInCalendar    = false;
            firstDayOfWeek           = 1;
            hideWeatherCityName      = false;
            hideWeatherTimezone      = false;
            name                     = "Liège";
            showCalendarEvents       = true;
            showCalendarWeather      = true;
            showWeekNumberInCalendar = false;
            use12hourFormat          = false;
            useFahrenheit            = false;
            weatherEnabled           = true;
            weatherShowEffects       = true;
          };


          network = {
            bluetoothDetailsViewMode    = "grid";
            bluetoothHideUnnamedDevices = false;
            bluetoothRssiPollIntervalMs = 10000;
            bluetoothRssiPollingEnabled = false;
            wifiDetailsViewMode         = "grid";
            wifiEnabled                 = true;
          };

          nightLight = {
            autoSchedule  = true;
            dayTemp       = "6500";
            enabled       = false;
            forced        = false;
            manualSunrise = "08:00";
            manualSunset  = "19:30";
            nightTemp     = "4000";
          };

          notifications = {
            backgroundOpacity         = 1;
            criticalUrgencyDuration   = 30;
            enableKeyboardLayoutToast = true;
            enabled                   = true;
            location                  = "top_right";
            lowUrgencyDuration        = 6;
            monitors                  = [];
            normalUrgencyDuration     = 10;
            overlayLayer              = true;
            respectExpireTimeout      = false;
            saveToHistory             = {
              critical = true;
              low      = true;
              normal   = true; };
            sounds = {
              criticalSoundFile = "";
              enabled           = false;
              excludedApps      = "discord,firefox,chrome,chromium,edge";
              lowSoundFile      = "";
              normalSoundFile   = "";
              separateSounds    = false;
              volume            = 0.5; };
          };

          osd = {
            autoHideMs        = 2000;
            backgroundOpacity = 1;
            enabled           = true;
            enabledTypes      = [ 0 1 2 4 ];
            location          = "top_right";
            monitors          = [];
            overlayLayer      = true;
          };

          sessionMenu = {
            countdownDuration  = 10000;
            enableCountdown    = false;
            largeButtonsLayout = "grid";
            largeButtonsStyle  = false;
            position           = "center";
            powerOptions       = [
              { enabled = true;
                action  = "lock"; }

              { enabled = true;
                action  = "suspend"; }

              { enabled = true;
                action  = "hibernate"; }

              { enabled = true;
                action  = "reboot"; }

              { enabled = true;
                action  = "logout"; }

              { enabled = true;
                action  = "shutdown"; }
            ];
            showHeader         = true;
            showNumberLabels   = true;
          };

          systemMonitor = {
            cpuCriticalThreshold   = 90;
            cpuPollingInterval     = 3000;
            cpuWarningThreshold    = 80;
            criticalColor          = "";
            diskCriticalThreshold  = 90;
            diskPollingInterval    = 3000;
            diskWarningThreshold   = 80;
            enableDgpuMonitoring   = false;
            externalMonitor        = "resources || missioncenter || jdsystemmonitor || corestats || system-monitoring-center || gnome-system-monitor || plasma-systemmonitor || mate-system-monitor || ukui-system-monitor || deepin-system-monitor || pantheon-system-monitor";
            gpuCriticalThreshold   = 90;
            gpuPollingInterval     = 3000;
            gpuWarningThreshold    = 80;
            loadAvgPollingInterval = 3000;
            memCriticalThreshold   = 90;
            memPollingInterval     = 3000;
            memWarningThreshold    = 80;
            networkPollingInterval = 3000;
            tempCriticalThreshold  = 90;
            tempPollingInterval    = 3000;
            tempWarningThreshold   = 80;
            useCustomColors        = false;
            warningColor           = "";
          };

          templates = {
            activeTemplates     = [
              { id      = "cava";
                enabled = true; }

              { id      = "ghostty";
                enabled = true; }

              { id      = "gtk";
                enabled = true; }

              { id      = "helix";
                enabled = true; }

              { id      = "kcolorscheme";
                enabled = true; }

              { id      = "niri";
                enabled = true; }

              { id      = "qt";
                enabled = true; }

              { id      = "yazi";
                enabled = true; }

              { id      = "zed";
                enabled = true; }
            ];
            enableUserTemplates = false;
          };

          ui = {
            bluetoothDetailsViewMode    = "grid";
            bluetoothHideUnnamedDevices = false;
            boxBorderEnabled            = false;
            fontDefault                 = "JetBrainsMono Nerd Font";
            fontDefaultScale            = 1;
            fontFixed                   = "JetBrainsMono Nerd Font Mono";
            fontFixedScale              = 1;
            networkPanelView            = "wifi";
            panelBackgroundOpacity      = 0.4;
            panelsAttachedToBar         = false;
            settingsPanelMode           = "centered";
            tooltipsEnabled             = true;
            wifiDetailsViewMode         = "grid";
          };

          wallpaper = {
            directory                     = "~/Pictures/Wallpapers"; # @todo Find how to make it work so I don't have to write it for every user
            enableMultiMonitorDirectories = false;
            enabled                       = true;
            fillColor                     = "#000000";
            fillMode                      = "crop";
            hideWallpaperFilenames        = false;
            monitorDirectories            = [];
            overviewEnabled               = false;
            panelPosition                 = "center";
            randomEnabled                 = false;
            randomIntervalSec             = 300;
            recursiveSearch               = false;
            setWallpaperOnAllMonitors     = true;
            solidColor                    = "#1a1a2e";
            transitionDuration            = 1500;
            transitionEdgeSmoothness      = 0.05;
            transitionType                = "fade";
            useSolidColor                 = false;
            useWallhaven                  = false;
            wallhavenApiKey               = "";
            wallhavenCategories           = "111";
            wallhavenOrder                = "desc";
            wallhavenPurity               = "100";
            wallhavenQuery                = "";
            wallhavenRatios               = "";
            wallhavenResolutionHeight     = "";
            wallhavenResolutionMode       = "atleast";
            wallhavenResolutionWidth      = "";
            wallhavenSorting              = "relevance";
            wallpaperChangeMode           = "random";
          };
        };
      };
    };
  };
}
