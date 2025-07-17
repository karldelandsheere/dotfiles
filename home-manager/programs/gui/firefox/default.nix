# Firefox
# -------
# Based on several dotfiles but a lot on those
#   https://gitlab.com/maximilian_dietrich/nixos/-/tree/restructure-add-workstation/modules/graphical/apps/browser
#
# @todo also, check if it's possible to pre-populate some bitwarden info
{ config, pkgs, lib, ... }: let
  extensions = import ./extensions.nix;
in
{
  config = {
    programs.firefox = {
      enable = true;

      # https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265/16
      # ------------------------------------------------------------------------------

      # Policies (check about:policies#documentation for options)
      # --------
      policies = {
        # Ordered by alphabetical order        
        AppAutoUpdate = false;
        AppUpdateURL = "https://localhost";
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
        BackgroundAppUpdate = false;

        # Bookmarks = {
        #   "type": "array",
        #   "items": {
        #     "type": "object",
        #     "properties": {
        #       "Title": {
        #         "type": "string"
        #       },
        #       "URL": {
        #         "type": "URL"
        #       },
        #       "Favicon": {
        #         "type": "URLorEmpty"
        #       },
        #       "Placement": {
        #         "type": "string",
        #         "enum": [
        #           "toolbar",
        #           "menu"
        #         ]
        #       },
        #       "Folder": {
        #         "type": "string"
        #       }
        #     },
        #     "required": [
        #       "Title",
        #       "URL"
        #     ]
        #   }
        # };

        CaptivePortal = false;
        # Certificates = {
        #   "ImportEnterpriseRoots": {
        #     "type": "boolean"
        #   },
        #   "Install": {
        #     "type": "array",
        #     "items": {
        #       "type": "string"
        #     }
        #   }
        # };
        ContentAnalysis = { Enabled = false; };
        Cookies = {
          Behavior = "reject";
          BehaviorPrivateBrowsing = "reject";
          RejectTracker = true;
        };
        DisableAccounts = true;
        DisableAppUpdate = true;
        DisableFeedbackCommands = true;
        DisableFirefoxAccounts = true;
        DisableFirefoxScreenshots = true;
        DisableFirefoxStudies = true;
        DisableFormHistory = true;
        DisableMasterPasswordCreation = true;
        DisablePasswordReveal = true;
        DisableProfileImport = true;
        DisableProfileRefresh = true;
        DisableSetDesktopBackground = true;
        DisableSystemAddonUpdate = true;
        DisableTelemetry = true;
        DisplayBookmarksToolbar = "always";
        DisplayMenuBar = "default-off";
        DNSOverHTTPS = { Enabled = false; };
        DontCheckDefaultBrowser = true;
        # DownloadDirectory = "/path";
        EnableTrackingProtection  = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
          EmailTracking = true;
        };
        EncryptedMediaExtensions = { Enabled = false; };

        # Extensions = {
        #   Install = [
        #     "https://addons.mozilla.org/en-US/firefox/downloads/latest/{446900e4-71c2-419f-a6a7-df9c091e268b}/latest.xpi"
        #     "https://addons.mozilla.org/en-US/firefox/downloads/latest/CanvasBlocker@kkapsner.de/latest.xpi"
        #     "https://addons.mozilla.org/en-US/firefox/downloads/latest/{74145f27-f039-47ce-a470-a662b129930a}/latest.xpi"
        #     "https://addons.mozilla.org/en-US/firefox/downloads/latest/gdpr@cavi.au.dk/latest.xpi"
        #     "https://addons.mozilla.org/en-US/firefox/downloads/latest/jid1-MnnxcxisBPnSXQ@jetpack/latest.xpi"
        #     "https://addons.mozilla.org/en-US/firefox/downloads/latest/uBlock0@raymondhill.net/latest.xpi"
        #   ];
        #   Uninstall = [
        #     "google@search.mozilla.org"
        #     "bing@search.mozilla.org"
        #     "amazondotcom@search.mozilla.org"
        #     "ebay@search.mozilla.org"
        #     "twitter@search.mozilla.org"
        #   ];
        # };

        ExtensionSettings = lib.mapAttrs(
          _name: extension: lib.nameValuePair extension.id {
            inherit (extension) installation_mode private_browsing settings permissions;
            install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${extension.id}/latest.xpi";
          }
        ) extensions;
        ExtensionUpdate = false;
        FirefoxHome = {
          Highlights = false;
          Locked = true;
          Pocket = false;
          Search = false;
          Snippets = false;
          SponsoredPocket = false;
          SponsoredStories = false;
          SponsoredTopSites = false;
          Stories = false;
          TopSites = false;
        };
        FirefoxSuggest = {
          ImproveSuggest = false;
          Locked = true;
          SponsoredSuggestions = false;
          WebSuggestions = false;
        };
        # Handlers = {}; # @todo implement this
        Homepage = {
          # URL = "";
          Locked = true;
          StartPage = "none"; # "homepage" when there will be one
        };
        InstallAddonsPermission = { Default = true; };
        LegacyProfiles = true;
        # LegacySameSiteCookieBehaviorEnabled = true;
        # ManagedBookmarks = [
        #   {
        #     "toplevel_name": "My managed bookmarks folder"
        #   },
        #   {
        #     "url": "example.com",
        #     "name": "Example"
        #   },
        #   {
        #     "name": "Mozilla links",
        #     "children": [
        #       {
        #         "url": "https://mozilla.org",
        #         "name": "Mozilla.org"
        #       },
        #       {
        #         "url": "https://support.mozilla.org/",
        #         "name": "SUMO"
        #       }
        #     ]
        #   }
        # ];
        NetworkPrediction = false;
        NewTabPage = false;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        PasswordManagerEnabled = false;

        # "Permissions": { # @todo implement that, with a loop for easier management
        #   "Camera": {
        #     "Allow": ["https://example.org","https://example.org:1234"],
        #     "Block": ["https://example.edu"],
        #     "BlockNewRequests": true | false,
        #     "Locked": true | false
        #   },
        #   "Microphone": {
        #     "Allow": ["https://example.org"],
        #     "Block": ["https://example.edu"],
        #     "BlockNewRequests": true | false,
        #     "Locked": true | false
        #   },
        #   "Location": {
        #     "Allow": ["https://example.org"],
        #     "Block": ["https://example.edu"],
        #     "BlockNewRequests": true | false,
        #     "Locked": true | false
        #   },
        #   "Notifications": {
        #     "Allow": ["https://example.org"],
        #     "Block": ["https://example.edu"],
        #     "BlockNewRequests": true | false,
        #     "Locked": true | false
        #   },
        #   "Autoplay": {
        #     "Allow": ["https://example.org"],
        #     "Block": ["https://example.edu"],
        #     "Default": "allow-audio-video" | "block-audio" | "block-audio-video",
        #     "Locked": true | false
        #   }
        # };

        PictureInPicture = { Enabled = false; Locked = true; };
        PopupBlocking = {
          Default = true;
          # Allow = [];
        };
        PostQuantumKeyAgreementEnabled = true;

        Preferences = let  # (check about:config for options)
          lock-false = { Value = false; Status = "locked"; };
          lock-true  = { Value = true;  Status = "locked"; };
        in
        {
          "browser.aboutConfig.showWarning" = lock-false;
          "browser.aboutwelcome.enabled" = lock-false;
          "browser.bookmarks.addedImportButton" = lock-false;
          "browser.bookmarks.autoExportHTML" = true;
          "browser.bookmarks.restore_default_bookmarks" = lock-false;
          "browser.cache.offline.enable" = lock-false;
          "browser.contentblocking.category" = { Value = "strict"; Status = "locked"; }; # set to "custom"?
          "browser.crashReports.unsubmittedCheck.autoSubmit" = lock-false;
          "browser.crashReports.unsubmittedCheck.autoSubmit2" = lock-false;
          "browser.crashReports.unsubmittedCheck.enabled" = lock-false;
          "browser.disableResetPrompt" = lock-true;
          "browser.discovery.enabled" = lock-false;
          # "browser.display.use_document_fonts" = 1;
          "browser.download.always_ask_before_handling_new_types" = lock-true;
          "browser.download.manager.addToRecentDocs" = lock-false;
          "browser.download.open_pdf_attachments_inline" = lock-true;
          # "browser.download.panel.shown" = true;
          "browser.download.start_downloads_in_tmp_dir" = true;
          # "browser.download.useDownloadDir" = false;
          "browser.feeds.showFirstRunUI" = false;
          "browser.fixup.alternate.enabled" = lock-false;
          # "browser.fixup.domainsuffixwhitelist.home" = true;
          # "browser.fixup.domainwhitelist.server.home" = true;
          "browser.formfill.enable" = lock-false;
          "browser.helperApps.deleteTempFileOnExit" = lock-true;
          # "browser.link.open_newwindow.restriction" = 0;
          "browser.messaging-system.whatsNewPanel.enabled" = lock-false;
          "browser.newtab.preload" = lock-false;
          # "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
          # "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = lock-false;
          "browser.newtabpage.activity-stream.feeds.snippets" = lock-false;
          "browser.newtabpage.activity-stream.feeds.telemetry" = lock-false;
          "browser.newtabpage.activity-stream.feeds.topsites" = lock-false;
          "browser.newtabpage.activity-stream.feeds.weatherfeed" = lock-false;
          "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeVisited" = lock-false;
          "browser.newtabpage.activity-stream.showSponsored" = lock-false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
          "browser.newtabpage.activity-stream.showWeather" = lock-false;
          "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
          "browser.newtabpage.activity-stream.system.showWeather" = lock-false;
          "browser.newtabpage.activity-stream.telemetry" = lock-false;
          "browser.newtabpage.activity-stream.weather.locationSearchEnabled" = lock-false;
          "browser.newtabpage.enabled" = lock-false;
          "browser.newtabpage.enhanced" = lock-false;
          "browser.newtabpage.introShown" = lock-true;
          "browser.ping-centre.telemetry" = lock-false;
          "browser.preferences.moreFromMozilla" = lock-false;
          # "browser.privatebrowsing.forceMediaMemoryCache" = true;
          # "browser.privatebrowsing.vpnpromourl" = "";
          # "browser.protections_panel.infoMessage.seen" = true; # disable tracking protection info
          # "browser.rights.3.shown" = true;
          "browser.safebrowsing.appRepURL" = "";
          "browser.safebrowsing.blockedURIs.enabled" = lock-false;
          "browser.safebrowsing.downloads.enabled" = lock-false;
          "browser.safebrowsing.downloads.remote.enabled" = lock-false;
          "browser.safebrowsing.downloads.remote.url" = "";
          "browser.safebrowsing.enabled" = lock-false;
          "browser.safebrowsing.malware.enabled" = lock-false;
          "browser.safebrowsing.phishing.enabled" = lock-false;
  				"browser.search.defaultenginename" = "DuckDuckGo";
  				"browser.search.order.1" = "DuckDuckGo";
          # "browser.search.separatePrivateDefault.ui.enabled" = true;
          "browser.search.suggest.enabled" = lock-false;
          "browser.search.suggest.enabled.private" = lock-false;
          "browser.selfsupport.url" = "";
          "browser.send_pings" = lock-false;
          "browser.sessionstore.interval" = 60000;
          "browser.sessionstore.privacy_level" = 0;
          "browser.shell.checkDefaultBrowser" = lock-false;
          "browser.shell.defaultBrowserCheckCount" = 1;
          # "browser.ssb.enabled" = true; # enable site specific browser (@todo try that maybe?)
          "browser.startup.homepage_override.mstone" = "ignore";
          "browser.startup.page" = 3; # restore previous session
          "browser.tabs.crashReporting.sendReport" = lock-false;
          "browser.tabs.closeWindowWithLastTab" = lock-false;
          "browser.tabs.inTitlebar" = 1;
          "browser.tabs.loadBookmarksInTabs" = true; # open bookmarks in new tab
          # "browser.tabs.loadDivertedInBackground" = false; # open new tab in background
          # "browser.tabs.loadInBackground" = true; # open new tab in background
          # "browser.tabs.tabmanager.enabled" = false;
          "browser.tabs.warnOnClose" = false;
          "browser.tabs.warnOnCloseOtherTabs" = true;
          "browser.tabs.warnOnOpen" = false;
          "browser.tabs.warnOnQuit" = false;
          "browser.theme.toolbar-theme" = 0;
          "browser.toolbarbuttons.introduced.sidebar-button" = true;
          "browser.toolbars.bookmarks.visibility" = "always"; # show bookmarks toolbar
          "browser.topsites.contile.enabled" = lock-false;
          "browser.translations.automaticallyPopup" = lock-false;
          "browser.uitour.enabled" = lock-false;
          "browser.urlbar.groupLabels.enabled" = lock-false;
          "browser.urlbar.quicksuggest.enabled" = lock-false;
          "browser.urlbar.quicksuggest.migrationVersion" = 2;
          "browser.urlbar.quicksuggest.scenario" = "history";
          "browser.urlbar.showSearchSuggestionsFirst" = lock-false;
          "browser.urlbar.speculativeConnect.enabled" = lock-false;
          # "browser.urlbar.suggest.calculator" = true;
          "browser.urlbar.suggest.quicksuggest.nonsponsored" = lock-false;
          "browser.urlbar.suggest.quicksuggest.sponsored" = lock-false;
          "browser.urlbar.suggest.topsites" = lock-false;
          "browser.urlbar.suggest.trending" = lock-false;
          "browser.urlbar.suggest.yelp" = lock-false;
          "browser.urlbar.suggest.searches" = lock-false;
          "browser.urlbar.trending.featureGate" = lock-false;
          "browser.urlbar.trimURLs" = lock-false;
          # "browser.urlbar.update2.engineAliasRefresh" = true;
          # "browser.xul.error_pages.expert_bad_cert" = true;
          # "captivedetect.canonicalURL" = "";
          # "cookiebanners.service.enableGlobalRules" = true;
          # "cookiebanners.service.mode" = 1;
          # "cookiebanners.service.mode.privateBrowsing" = 1;
          "datareporting.policy.dataSubmissionEnabled" = lock-false;
          "datareporting.policy.dataSubmissionPolicyBypassNotification" = lock-true;
          # "datareporting.sessions.current.clean" = true;
          # "devtools.toolbox.host" = "right"; # move devtools to right
          "dom.battery.enabled" = lock-false;
          "dom.event.clipboardevents.enabled" = lock-false;
          "dom.private-attribution.submission.enabled" = lock-false;
          "dom.security.https_first" = true;
          # "dom.security.https_only_mode" = true; # force https
          "dom.security.sanitizer.enabled" = true;
          "dom.webaudio.enabled" = lock-false;
          # "editor.truncate_user_pastes" = false;
          "extensions.ClearURLs@kevinr.whiteList" = "";
          "extensions.autoDisableScopes" = 14;
          "extensions.formautofill.addresses.enabled" = false;
          "extensions.formautofill.creditCards.enabled" = lock-false;
          "extensions.getAddons.cache.enabled" = lock-false;
          "extensions.getAddons.showPane" = lock-false;
          "extensions.greasemonkey.stats.optedin" = lock-false;
          "extensions.greasemonkey.stats.url" = "";
          "extensions.htmlaboutaddons.recommendations.enabled" = lock-false;
          "extensions.pocket.enabled" = lock-false;
          # "extensions.postDownloadThirdPartyPrompt" = false;
          "extensions.screenshots.disabled" = lock-true;
          "extensions.shield-recipe-client.api_url" = "";
          "extensions.shield-recipe-client.enabled" = lock-false;
          "extensions.webservice.discoverURL" = "";
          # "full-screen-api.ignore-widgets" = true; # fullscreen within window
          # "geo.provider.network.url" = "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%";
          "keyword.enabled" = true;
          "media.autoplay.default" = 1;
          "media.autoplay.enabled" = lock-false;
          "media.eme.enabled" = lock-false;
          "media.ffmpeg.vaapi.enabled" = true; # enable hardware acceleration
          "media.gmp-widevinecdm.enabled" = lock-false;
          "media.navigator.enabled" = lock-false;
          "media.peerconnection.enabled" = lock-false;
          "media.rdd-vpx.enabled" = true; # enable hardware acceleration
          # "media.videocontrols.picture-in-picture.video-toggle.enabled" = true; # disable picture in picture button
          # "media.peerconnection.ice.default_address_only" = true;
          # "media.peerconnection.ice.proxy_only_if_behind_proxy" = true;
          "media.video_stats.enabled" = lock-false;
          "network.allow-experiments" = lock-false;
          # "network.auth.subresource-http-auth-allow" = 1;
          # "network.buffer.cache.count" = 128;
          # "network.buffer.cache.size" = 262144;
          "network.captive-portal-service.enabled" = lock-false;
          "network.cookie.cookieBehavior" = 1;
          "network.cookie.sameSite.noneRequiresSecure" = lock-true;
          # "network.connectivity-service.enabled" = false;
          "network.dns.disablePrefetch" = lock-true;
          "network.dns.disablePrefetchFromHTTPS" =lock-true;
          # "network.dns.max_high_priority_threads" = 8;
          # "network.dnsCacheExpiration" = 3600;
          # "network.http.max-connections" = 1800;
          # "network.http.max-persistent-connections-per-server" = 10;
          # "network.http.max-urgent-start-excessive-connections-per-host" = 5;
          # "network.http.pacing.requests.enabled" = false;
          "network.http.referer.spoofSource" = lock-true;
          "network.http.referer.XOriginTrimmingPolicy" = 2;
          "network.http.speculative-parallel-limit" = 0;
          "network.IDN_show_punycode" = lock-true;
          "network.predictor.enabled" = lock-false;
          "network.predictor.enable-prefetch" = lock-false;
          "network.prefetch-next" = lock-false;
          # "network.ssl_tokens_cache_capacity" = 10240;
          "network.trr.mode" = 5;
          # "pdfjs.enableScripting" = false;
          # "permissions.default.desktop-notification" = 2;
          # "permissions.default.geo" = 2;
          # "permissions.manager.defaultsUrl" = "";
          "privacy.globalprivacycontrol.enabled" = lock-true;
          # "privacy.history.custom" = true;
          # "privacy.userContext.ui.enabled" = true;
          "security.mixed_content.block_display_content" = true;
          "security.mixed_content.upgrade_display_content" = true;
          # "security.OCSP.enabled" = 0;
          # "security.pki.crlite_mode" = 2;
          # "security.remote_settings.crlite_filters.enabled" = true;
          # "security.insecure_connection_text.enabled" = true;
          # "security.insecure_connection_text.pbmode.enabled" = true;
          # "security.ssl.treat_unsafe_negotiation_as_broken" = true;
          # "security.tls.enable_0rtt_data" = false;
          "signon.autofillForms" = lock-false;
          "signon.formlessCapture.enabled" = lock-false;
          "signon.privateBrowsingCapture.enabled" = lock-false;
          "signon.rememberSignons" = lock-false; # Using Bitwarden for this
          # "svg.context-properties.content.enabled" = true;
          # "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          # "trailhead.firstrun.didSeeAboutWelcome" = true;
          # "webchannel.allowObject.urlWhitelist" = "";

          # # THEME ADJUSTMENTS
          # "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          # "browser.compactmode.show" = true;
          # "browser.uidensity" = 1;
          # "browser.display.focus_ring_on_anything" = true;
          # "browser.display.focus_ring_style" = 0;
          # "browser.display.focus_ring_width" = 0;
          # "layout.css.prefers-color-scheme.content-override" = 2;
        };
        PrintingEnabled = true;
        PrivateBrowsingModeAvailability = 0; # 0 = available / 2 = forced
        PromptForDownloadLocation = false;
        SanitizeOnShutdown = {
          Cache = true;
          Cookies = true;
          FormData = true;
          History = true;
          Locked = false;
          Sessions = false;
          SiteSettings = true;
        };
        SearchBar = "unified";

        SearchEngines = {
          Default = "DuckDuckGo";
          PreventInstalls = true;
          Remove = [ "Bing" "Google" "Wikipedia" "Youtube" ]; # @todo Correct this
          # Add = [
            # {
            #   "Name": "Example1",
            #   "URLTemplate": "https://www.example.org/q={searchTerms}",
            #   "Method": "GET" | "POST",
            #   "IconURL": "https://www.example.org/favicon.ico",
            #   "Alias": "example",
            #   "Description": "Description",
            #   "PostData": "name=value&q={searchTerms}",
            #   "SuggestURLTemplate": "https://www.example.org/suggestions/q={searchTerms}"
            # }
          # ];
        };

        SearchSuggestEnabled = false;
        ShowHomeButton = false;
        SkipTermsOfUse = true;
        # SSLVersionMin = "tls1.2";
        StartDownloadsInTempDirectory = true;
        TranslateEnabled = false;
        UserMessaging = {
          ExtensionRecommendations = false;
          FeatureRecommendations = false;
          FirefoxLabs = false;
          Locked = true;
          MoreFromMozilla = false;
          SkipOnboarding = false;
          UrlbarInterventions = false;
        };
        UseSystemPrintDialog = true;
      };

      # Profile (check about:config for options)
      # -------
      profiles.default = {
        id = 0;
        name = "default";
        isDefault = true;
        settings = {
          "app.normandy.api_url" = "";
          "app.normandy.enabled" = false;
          "app.normandy.first_run" = false;
          "app.shield.optoutstudies.enabled" = false;
          "beacon.enabled" = false;
          "breakpad.reportURL" = "";
          "datareporting.healthreport.service.enabled" = false;
          "datareporting.healthreport.uploadEnabled" = false;
          "device.sensors.ambientLight.enabled" = false;
          "device.sensors.enabled" = false;
          "device.sensors.motion.enabled" = false;
          "device.sensors.orientation.enabled" = false;
          "device.sensors.proximity.enabled" = false;
          "devtools.cache.disabled" = true;
          "devtools.onboarding.telemetry.logged" = false;
          "experiments.activeExperiment" = false;
          "experiments.enabled" = false;
          "experiments.manifest.uri" = "";
          "experiments.supported" = false;
          "findbar.highlightAll" = true;
          "privacy.donottrackheader.enabled" = true;
          "privacy.donottrackheader.value" = 1;
          "privacy.firstparty.isolate" = true;
          "privacy.query_stripping" = true;
          "privacy.resistFingerprinting" = true;
          "privacy.usercontext.about_newtab_segregation.enabled" = true;
          "sidebar.backupState" = {
            "launcherWidth" = 64;
            "expandedLauncherWidth" = 256;
            "launcherExpanded" = false;
            "launcherVisible" = true;
            "panelOpen" = false;
          };
          "sidebar.main.tools" = "aichat,history,bookmarks";
          "sidebar.revamp" = true;
          "sidebar.revamp.round-content-area" = true;
          "sidebar.verticalTabs" = true;
          "sidebar.visibility" = "expand-on-hover";
          "toolkit.coverage.opt-out" = true;
          "toolkit.coverage.endpoint.base" = "";
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.cachedClientID" = "";
          "toolkit.telemetry.coverage.opt-out" = true;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.firstShutdownPing.enabled" = false;
          "toolkit.telemetry.hybridContent.enabled" = false;
          "toolkit.telemetry.newProfilePing.enabled" = false;
          "toolkit.telemetry.prompted" = 2;
          "toolkit.telemetry.rejected" = true;
          "toolkit.telemetry.reportingpolicy.firstRun" = false;
          "toolkit.telemetry.server" = "";
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.unifiedIsOptIn" = false;
          "toolkit.telemetry.updatePing.enabled" = false;
          "urlclassifier.features.socialtracking.skipURLs" = "*.instagram.com, *.twitter.com, *.twimg.com";
          "urlclassifier.trackingSkipURLs" = "*.reddit.com, *.twitter.com, *.twimg.com, *.tiktok.com";
          "webgl.disabled" = true;
          "webgl.renderer-string-override" = " ";
          "webgl.vendor-string-override" = " ";






        




          # "browser.uiCustomization.navBarWhenVerticalTabs" = [
          #   "back-button"
          #   "forward-button"
          #   "stop-reload-button"
          #   "customizableui-special-spring1"
          #   "vertical-spacer"
          #   "urlbar-container"
          #   "customizableui-special-spring2"
          #   "save-to-pocket-button"
          #   "downloads-button"
          #   "unified-extensions-button"
          #   "fxa-toolbar-menu-button"
          #   "ublock0_raymondhill_net-browser-action"
          #   "keepassxc-browser_keepassxc_org-browser-action"
          #   "library-button"
          #   "sidebar-button"
          #   "history-panelmenu"
          #   "firefox-view-button"
          #   "alltabs-button"
          # ];
          # "browser.uiCustomization.horizontalTabstrip" = [
          #   "firefox-view-button"
          #   "tabbrowser-tabs"
          #   "new-tab-button"
          #   "alltabs-button"
          # ];
          # "browser.uiCustomization.state" = {
          #   "placements" = {
          #     "widget-overflow-fixed-list" = [ ];
          #     "unified-extensions-area" = [
          #       "sponsorblocker_ajay_app-browser-action"
          #       "firefoxcolor_mozilla_com-browser-action"
          #     ];
          #     "nav-bar" = [
          #       "back-button"
          #       "forward-button"
          #       "stop-reload-button"
          #       "customizableui-special-spring1"
          #       "vertical-spacer"
          #       "urlbar-container"
          #       "customizableui-special-spring2"
          #       "downloads-button"
          #       "unified-extensions-button"
          #       "zotero_chnm_gmu_edu-browser-action"
          #       "ublock0_raymondhill_net-browser-action"
          #       "keepassxc-browser_keepassxc_org-browser-action"
          #       "library-button"
          #       # "sidebar-button"
          #       "alltabs-button"
          #     ];
          #     "toolbar-menubar" = [ "menubar-items" ];
          #     "TabsToolbar" = [ ];
          #     "vertical-tabs" = [ "tabbrowser-tabs" ];
          #     "PersonalToolbar" = [ "personal-bookmarks" ];
          #   };
          #   "seen" = [
          #     "firefoxcolor_mozilla_com-browser-action"
          #     "keepassxc-browser_keepassxc_org-browser-action"
          #     "sponsorblocker_ajay_app-browser-action"
          #     "ublock0_raymondhill_net-browser-action"
          #     "developer-button"
          #   ];
          #   "dirtyAreaCache" = [
          #     "unified-extensions-area"
          #     "nav-bar"
          #     "vertical-tabs"
          #     "PersonalToolbar"
          #     "TabsToolbar"
          #     "toolbar-menubar"
          #   ];
          #   "currentVersion" = 21;
          #   "newElementCount" = 3;
          # };


          # "identity.fxaccounts.enabled" = false;

          # Layout
          # "browser.uiCustomization.state" = builtins.toJSON {
          #   currentVersion = 20;
          #   newElementCount = 5;
          #   dirtyAreaCache = [
          #     "nav-bar"
          #     "PersonalToolbar"
          #     "toolbar-menubar"
          #     "TabsToolbar"
          #     "widget-overflow-fixed-list"
          #   ];
          #   placements = {
          #     PersonalToolbar = [ "personal-bookmarks" ];
          #     TabsToolbar = [
          #       "tabbrowser-tabs"
          #       "new-tab-button"
          #       "alltabs-button"
          #     ];
          #     nav-bar = [
          #       "back-button"
          #       "forward-button"
          #       "stop-reload-button"
          #       "urlbar-container"
          #       "downloads-button"
          #       "ublock0_raymondhill_net-browser-action"
          #       "_testpilot-containers-browser-action"
          #       "reset-pbm-toolbar-button"
          #       "unified-extensions-button"
          #     ];
          #     toolbar-menubar = [ "menubar-items" ];
          #     unified-extensions-area = [ ];
          #     widget-overflow-fixed-list = [ ];
          #   };
          #   seen = [
          #     "save-to-pocket-button"
          #     "developer-button"
          #     "ublock0_raymondhill_net-browser-action"
          #     "_testpilot-containers-browser-action"
          #   ];
          # };



          

  				# "widget.use-xdg-desktop-portal.file-picker" = 1;
  				# "browser.compactmode.show" = true;
  				# "browser.cache.disk.enable" = false;
  				# "widget.disable-workspace-management" = true;
  				# "browser.toolbars.bookmarks.visibility" = "never";
  				# "ui.key.menuAccessKeyFocuses" = false;
  			};






        search = {
          force = true;
          default = "ddg";
          engines = {
            # don't need these default ones
            # amazondotcom-us.metaData.hidden = true;
            # bing.metaData.hidden = true;
            # ebay.metaData.hidden = true;

            github = {
              name = "Github";
              urls = [ { template = "https://github.com/search?q={searchTerms}"; } ];
              iconMapObj."32" = "https://github.githubassets.com/favicons/favicon-dark.png";
              definedAliases = [ "@gh" ];
            };

            nixpkgs = {
              name = "Nixpkgs";
              urls = lib.singleton {
                template = "https://github.com/search";
                params = lib.attrsToList {
                  "type" = "code";
                  "q" = "repo:NixOS/nixpkgs lang:nix {searchTerms}";
                };
              };
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@npkgs" ];
            };

            github-nix = {
              name = "Github Nix Code";
              urls = lib.singleton {
                template = "https://github.com/search";
                params = lib.attrsToList {
                  "type" = "code";
                  "q" = "lang:nix NOT is:fork {searchTerms}";
                };
              };
              iconMapObj."32" = "https://github.com/favicon.ico";
              definedAliases = [ "@ghn" ];
            };

            youtube = {
              name = "Youtube";
              urls = [ { template = "https://www.youtube.com/results?search_query={searchTerms}"; } ];
              iconMapObj."32" = "https://www.youtube.com/favicon.ico";
              definedAliases = [ "@y" ];
            };
          };
        };




        # settings = {      
        #   # I18n
        #   # ----
        #   "intl.accept_languages" = "en-US, en, fr-BE, fr";

        # };
      };
    };


    home.sessionVariables = {
      BROWSER = "${pkgs.firefox}/bin/firefox";
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_DBUS_REMOTE = "1";
    };
  };
}
