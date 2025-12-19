# Librewolf
# ---------

{ config, osConfig, pkgs, lib, ... }: let
  bookmarks  = import ./bookmarks.nix;
  extensions = import ./extensions.nix;
in
{
  config = {
    programs.librewolf = {
      enable = true;
      # package = pkgs.librewolf.overrideAttrs (_old: {
      #   extraNativeMessagingHosts = with pkgs; [pywalfox-native];
      # });

      policies = {
        # Install/update are managed through NixOS
        AppAutoUpdate = false;
        AppUpdateURL = "https://localhost";
        BackgroundAppUpdate = false;
        DisableAppUpdate = true;
        DisableSystemAddonUpdate = true;
        ExtensionUpdate = false;
        InstallAddonsPermission = { Default = false; };
        ManualAppUpdateOnly = true;


        # No autofill
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;


        # Passwords are managed by Bitwarden
        DisableMasterPasswordCreation = true;
        OfferToSaveLogins = false;
        PasswordManagerEnabled = false;

        
        # No tracking, telemetry, fingerprinting, and less history
        ContentAnalysis = { Enabled = false; };
        Cookies = {
          Behavior = "reject-tracker-and-partition-foreign";
          BehaviorPrivateBrowsing = "reject";
          Locked = true;
          RejectTracker = true;
        };
        DisableFeedbackCommands = true;
        DisableFirefoxStudies = true;
        DisableFormHistory = true;
        DisableTelemetry = true;
        DNSOverHTTPS = { Enabled = false; };
        EnableTrackingProtection  = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
          EmailTracking = true;
        };
        PrivateBrowsingModeAvailability = 0; # 0 = available / 2 = forced
        SanitizeOnShutdown = {
          Cache = true;
          Cookies = true;
          FormData = true;
          History = true;
          Locked = false;
          Sessions = false;
          SiteSettings = true;
        };


        # No profile
        DisableAccounts = true;
        DisableFirefoxAccounts = true;
        DisableProfileImport = true;
        DisableProfileRefresh = true;


        # Extensions
        ExtensionSettings = lib.mapAttrs(
          name: definition: {
            inherit (definition) installation_mode private_browsing settings permissions;
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/${definition.id}/latest.xpi";
          }
        ) extensions;
        

        # Bookmarks
        DisplayBookmarksToolbar = "always";
        NoDefaultBookmarks = false; # https://github.com/nix-community/home-manager/issues/5821
        # ManagedBookmarks = [
        #   {
        #     toplevel_name = "My managed bookmarks folder";
        #   }
          
        #   {
        #     url = "example.com";
        #     name = "Example";
        #   }
          
        #   {
        #     name = "Mozilla links";
        #     children = [
        #       {
        #         url = "https://mozilla.org";
        #         name = "Mozilla.org";
        #       }
              
        #       {
        #         url = "https://support.mozilla.org/";
        #         name = "SUMO";
        #       }
        #     ];
        #   }
        # ];


        # Search
        SearchBar = "unified";
        SearchEngines = {
          Default = "StartPage";
          PreventInstalls = true;
          Add = [
            {
              Name = "StartPage";
			        Description = "The world's most private search engine";
              Alias = "";
			        Method = "GET";
              URLTemplate = "https://www.startpage.com/sp/search?query={searchTerms}&cat=web&pl=opensearch";
			        IconURL = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAADb0lEQVRYhb2VXWgUVxiGv2gtWHrXBqExO2d2z5leWC80ilRKDTHunAPWhEi0gYY2mZkorYm7Z260oCiiFaQ3/RNqG/CvqAheKLSUUgpWqBdCKdbc+XMji4mhmk2MXTdvL9r4U+dsZtasH3x3877v852/IapUuzDHz6HF0/jU1/g10CgEIUq+xoMgxLAf4qIX4ksvj3c6O/FiRa8k1dyMF4IQm/0QV4MQiNkFP4+P+/rw0jOFewN4I9D4PUHwk61xrSePVVWF9+agAo2xqsMfdcnLwU8U7ufQHGhMzkL4dJe9EN3xwrdiga9xq4LZXV/jkK+xsTePZT05LPXzaPvvcBZMOj/EvQ/yWDwzgMZRo4nG0a4+vGrSduYxP9DYF4QoG/QXKoa/349M8O+1ippgb6wlJCIvh25fY8rgs6bS9LuiRJ7GT0SoiwtARORpfG5YhWNGURDifJSoR2NlknAiop5+1Psh7kdczYJR5IcYiRAMJw1/OJDGL1EDdYWGc7R9LyY/+QzlLwYxdfgkcPoscO5H/FYtwMQ9HBmfAMaKwOhfwPBt4GYBuH4ddqQAQBFP1+VqAQCcifADgAaT4HLExyXAfPXM1TSvvTNX6NiQH29bPzC2tr2/uLZ9y/i6joERAHMjJVeGrn79/Q/ncejb09i95yA2fbQHbeu3YsmKjTuTxltc9dqOwv+bOfJno6iRq2ykSKiJVCbbFDc8lWpNM0eORHlZXH5YSVtnO+oPA/mIlVEtMSZfYgt1I8rDFvJWfX3zy5UNMqqFCVU2rESZCXU8lZZvEdHj+1hncXcpE+qg7ci/I8MdBYu78f6KjLv7TSaPYOQ4E3KICfWnLdSdGb935KlY4dMTMaEGZzJN0kzI74hoTiIIW7g7bEeVZg/C/SoJABERNablcsbdC7MFYXEV+6/6JIjIvs2EGmRCFcz7rEYZd0+kuHyPOfKmESLjhlVBTJdlZe1GvibLHPkuE7LLymTVa7Z8nR7b44Xp1sXMUaOG8zBl8WzvM0HEAuXyTebIomElSpaQHTWHaOTStR113wAxmUq7rTWHSHF3AxPqQTSEHGMiu6LmECwjNzEhpwyP1O0UdxfVHoLLbRUeqks1ByAisoQ8YNiK0nMBICKyufzmqbdByHPPDYCI5jIu99lCDTNHFhl3TzQ0rH7lHy2g5RVQKFbLAAAAAElFTkSuQmCC";
			        SuggestURLTemplate = "https://www.startpage.com/osuggestions?q={searchTerms}";
            }

            {
              Name = "GitHub";
              Description = "GitHub";
              Alias = "@gh";
              Method = "GET";
              URLTemplate = "https://github.com/search?q={searchTerms}";
              IconURL = "https://github.com/favicon.ico";
              SuggestURLTemplate = "https://github.com/search?q={searchTerms}";
            }

            {
              Name = "GitHub (Nixpkgs)";
              Description = "Nixpkgs repo on GitHub";
              Alias = "@nixpkgs";
              Method = "GET";
              URLTemplate = "https://github.com/search?type=code&q=repo:NixOS/nixpkgs%20lang:nix%20{searchTerms}";
              IconURL = "https://nixos.org/favicon.ico";
              SuggestURLTemplate = "https://github.com/search?type=code&q=repo:NixOS/nixpkgs%20lang:nix%20{searchTerms}";
            }

            {
              Name = "GitHub (Nix code)";
              Description = "Nix/NixOS ressources on GitHub";
              Alias = "@ghn";
              Method = "GET";
              URLTemplate = "https://github.com/search?type=code&q=lang:nix%20NOT%20is:fork%20{searchTerms}";
              IconURL = "https://nixos.org/favicon.ico";
              SuggestURLTemplate = "https://github.com/search?type=code&q=lang:nix%20NOT%20is:fork%20{searchTerms}";
            }
          ];
          Remove = [ "Bing" "DuckDuckGo" "Google" "Youtube" ];
        };


        # UI/UX
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
        NewTabPage = false;
        PrintingEnabled = true;
        ShowHomeButton = false;
        SkipTermsOfUse = true;
        UseSystemPrintDialog = true;


        # Hardening
        PostQuantumKeyAgreementEnabled = true;
        SSLVersionMin = "tls1.2";
        StartDownloadsInTempDirectory = true;
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


        # Policy locked options (about:config)
        # Preferences = let
        #   lock-false = { Value = false; Status = "locked"; };
        #   lock-true  = { Value = true;  Status = "locked"; };
        # in
        # {
        #   "browser.aboutConfig.showWarning" = lock-false;
        #   "browser.aboutwelcome.enabled" = lock-false;
        #   "browser.bookmarks.addedImportButton" = lock-false;
        #   "browser.bookmarks.autoExportHTML" = true;
        #   "browser.bookmarks.restore_default_bookmarks" = lock-false;
        #   "browser.cache.offline.enable" = lock-false;
        #   "browser.contentblocking.category" = { Value = "strict"; Status = "locked"; }; # set to "custom"?
        #   "browser.crashReports.unsubmittedCheck.autoSubmit" = lock-false;
        #   "browser.crashReports.unsubmittedCheck.autoSubmit2" = lock-false;
        #   "browser.crashReports.unsubmittedCheck.enabled" = lock-false;
        #   "browser.disableResetPrompt" = lock-true;
        #   "browser.discovery.enabled" = lock-false;
        #   # "browser.display.use_document_fonts" = 1;
        #   "browser.download.always_ask_before_handling_new_types" = lock-true;
        #   "browser.download.manager.addToRecentDocs" = lock-false;
        #   "browser.download.open_pdf_attachments_inline" = lock-true;
        #   # "browser.download.panel.shown" = true;
        #   "browser.download.start_downloads_in_tmp_dir" = true;
        #   # "browser.download.useDownloadDir" = false;
        #   "browser.feeds.showFirstRunUI" = false;
        #   "browser.fixup.alternate.enabled" = lock-false;
        #   # "browser.fixup.domainsuffixwhitelist.home" = true;
        #   # "browser.fixup.domainwhitelist.server.home" = true;
        #   "browser.formfill.enable" = lock-false;
        #   "browser.helperApps.deleteTempFileOnExit" = lock-true;
        #   # "browser.link.open_newwindow.restriction" = 0;
        #   "browser.newtabpage.enhanced" = lock-false;
        #   "browser.newtabpage.introShown" = lock-true;
        #   "browser.ping-centre.telemetry" = lock-false;
        #   "browser.preferences.moreFromMozilla" = lock-false;
        #   # "browser.privatebrowsing.forceMediaMemoryCache" = true;
        #   # "browser.privatebrowsing.vpnpromourl" = "";
        #   # "browser.protections_panel.infoMessage.seen" = true; # disable tracking protection info
        #   # "browser.rights.3.shown" = true;
        #   "browser.safebrowsing.appRepURL" = "";
        #   "browser.safebrowsing.blockedURIs.enabled" = lock-false;
        #   "browser.safebrowsing.downloads.enabled" = lock-false;
        #   "browser.safebrowsing.downloads.remote.enabled" = lock-false;
        #   "browser.safebrowsing.downloads.remote.url" = "";
        #   "browser.safebrowsing.enabled" = lock-false;
        #   "browser.safebrowsing.malware.enabled" = lock-false;
        #   "browser.safebrowsing.phishing.enabled" = lock-false;
        #   # "browser.search.separatePrivateDefault.ui.enabled" = true;
        #   "browser.selfsupport.url" = "";
        #   "browser.send_pings" = lock-false;
        #   "browser.sessionstore.interval" = 60000;
        #   "browser.sessionstore.privacy_level" = 0;
        #   # "browser.ssb.enabled" = true; # enable site specific browser (@todo try that maybe?)
        #   "browser.tabs.crashReporting.sendReport" = lock-false;
        #   "browser.tabs.closeWindowWithLastTab" = lock-false;
        #   "browser.tabs.inTitlebar" = 1;
        #   "browser.tabs.loadBookmarksInTabs" = true; # open bookmarks in new tab
        #   # "browser.tabs.loadDivertedInBackground" = false; # open new tab in background
        #   # "browser.tabs.loadInBackground" = true; # open new tab in background
        #   # "browser.tabs.tabmanager.enabled" = false;
        #   "browser.tabs.warnOnClose" = false;
        #   "browser.tabs.warnOnCloseOtherTabs" = true;
        #   "browser.tabs.warnOnOpen" = false;
        #   "browser.tabs.warnOnQuit" = false;
        #   "browser.theme.toolbar-theme" = 0;
        #   "browser.toolbarbuttons.introduced.sidebar-button" = true;
        #   "browser.toolbars.bookmarks.visibility" = "always"; # show bookmarks toolbar
        #   "browser.topsites.contile.enabled" = lock-false;
        #   "browser.translations.automaticallyPopup" = lock-false;
        #   "browser.uitour.enabled" = lock-false;
        #   "browser.urlbar.groupLabels.enabled" = lock-false;
        #   "browser.urlbar.quicksuggest.enabled" = lock-false;
        #   "browser.urlbar.quicksuggest.migrationVersion" = 2;
        #   "browser.urlbar.quicksuggest.scenario" = "history";
        #   "browser.urlbar.showSearchSuggestionsFirst" = lock-false;
        #   "browser.urlbar.speculativeConnect.enabled" = lock-false;
        #   # "browser.urlbar.suggest.calculator" = true;
        #   "browser.urlbar.suggest.quicksuggest.nonsponsored" = lock-false;
        #   "browser.urlbar.suggest.quicksuggest.sponsored" = lock-false;
        #   "browser.urlbar.suggest.topsites" = lock-false;
        #   "browser.urlbar.suggest.trending" = lock-false;
        #   "browser.urlbar.suggest.yelp" = lock-false;
        #   "browser.urlbar.suggest.searches" = lock-false;
        #   "browser.urlbar.trending.featureGate" = lock-false;
        #   "browser.urlbar.trimURLs" = lock-false;
        #   # "browser.urlbar.update2.engineAliasRefresh" = true;
        #   # "browser.xul.error_pages.expert_bad_cert" = true;
        #   # "captivedetect.canonicalURL" = "";
        #   # "cookiebanners.service.enableGlobalRules" = true;
        #   # "cookiebanners.service.mode" = 1;
        #   # "cookiebanners.service.mode.privateBrowsing" = 1;
        #   "datareporting.policy.dataSubmissionEnabled" = lock-false;
        #   "datareporting.policy.dataSubmissionPolicyBypassNotification" = lock-true;
        #   # "datareporting.sessions.current.clean" = true;
        #   # "devtools.toolbox.host" = "right"; # move devtools to right
        #   "dom.battery.enabled" = lock-false;
        #   "dom.event.clipboardevents.enabled" = lock-false;
        #   "dom.private-attribution.submission.enabled" = lock-false;
        #   "dom.webaudio.enabled" = lock-false;
        #   # "editor.truncate_user_pastes" = false;
        #   "extensions.ClearURLs@kevinr.whiteList" = "";
        #   "extensions.autoDisableScopes" = 14;
        #   "extensions.formautofill.addresses.enabled" = false;
        #   "extensions.formautofill.creditCards.enabled" = lock-false;
        #   "extensions.getAddons.cache.enabled" = lock-false;
        #   "extensions.getAddons.showPane" = lock-false;
        #   "extensions.greasemonkey.stats.optedin" = lock-false;
        #   "extensions.greasemonkey.stats.url" = "";
        #   "extensions.htmlaboutaddons.recommendations.enabled" = lock-false;
        #   "extensions.pocket.enabled" = lock-false;
        #   # "extensions.postDownloadThirdPartyPrompt" = false;
        #   "extensions.screenshots.disabled" = lock-true;
        #   "extensions.shield-recipe-client.api_url" = "";
        #   "extensions.shield-recipe-client.enabled" = lock-false;
        #   "extensions.webservice.discoverURL" = "";
        #   # "full-screen-api.ignore-widgets" = true; # fullscreen within window
        #   # "geo.provider.network.url" = "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%";
        #   "keyword.enabled" = true;
        #   "media.autoplay.default" = 1;
        #   "media.autoplay.enabled" = lock-false;
        #   "media.eme.enabled" = lock-false;
        #   "media.ffmpeg.vaapi.enabled" = true; # enable hardware acceleration
        #   "media.gmp-widevinecdm.enabled" = lock-false;
        #   "media.navigator.enabled" = lock-false;
        #   "media.peerconnection.enabled" = lock-false;
        #   "media.rdd-vpx.enabled" = true; # enable hardware acceleration
        #   # "media.videocontrols.picture-in-picture.video-toggle.enabled" = true; # disable picture in picture button
        #   # "media.peerconnection.ice.default_address_only" = true;
        #   # "media.peerconnection.ice.proxy_only_if_behind_proxy" = true;
        #   "media.video_stats.enabled" = lock-false;
        #   "network.allow-experiments" = lock-false;
        #   # "network.auth.subresource-http-auth-allow" = 1;
        #   # "network.buffer.cache.count" = 128;
        #   # "network.buffer.cache.size" = 262144;
        #   "network.captive-portal-service.enabled" = lock-false;
        #   "network.cookie.cookieBehavior" = 1;
        #   "network.cookie.sameSite.noneRequiresSecure" = lock-true;
        #   # "network.connectivity-service.enabled" = false;
        #   "network.dns.disablePrefetch" = lock-true;
        #   "network.dns.disablePrefetchFromHTTPS" =lock-true;
        #   # "network.dns.max_high_priority_threads" = 8;
        #   # "network.dnsCacheExpiration" = 3600;
        #   # "network.http.max-connections" = 1800;
        #   # "network.http.max-persistent-connections-per-server" = 10;
        #   # "network.http.max-urgent-start-excessive-connections-per-host" = 5;
        #   # "network.http.pacing.requests.enabled" = false;
        #   "network.http.referer.spoofSource" = lock-true;
        #   "network.http.referer.XOriginTrimmingPolicy" = 2;
        #   "network.http.speculative-parallel-limit" = 0;
        #   "network.IDN_show_punycode" = lock-true;
        #   "network.predictor.enabled" = lock-false;
        #   "network.predictor.enable-prefetch" = lock-false;
        #   "network.prefetch-next" = lock-false;
        #   # "network.ssl_tokens_cache_capacity" = 10240;
        #   "network.trr.mode" = 5;
        #   # "pdfjs.enableScripting" = false;
        #   # "permissions.default.desktop-notification" = 2;
        #   # "permissions.default.geo" = 2;
        #   # "permissions.manager.defaultsUrl" = "";
        #   "privacy.globalprivacycontrol.enabled" = lock-true;
        #   # "privacy.history.custom" = true;
        #   # "privacy.userContext.ui.enabled" = true;
        #   "security.mixed_content.block_display_content" = true;
        #   "security.mixed_content.upgrade_display_content" = true;
        #   # "security.OCSP.enabled" = 0;
        #   # "security.pki.crlite_mode" = 2;
        #   # "security.remote_settings.crlite_filters.enabled" = true;
        #   # "security.insecure_connection_text.enabled" = true;
        #   # "security.insecure_connection_text.pbmode.enabled" = true;
        #   # "security.ssl.treat_unsafe_negotiation_as_broken" = true;
        #   # "security.tls.enable_0rtt_data" = false;
        #   "signon.autofillForms" = lock-false;
        #   "signon.formlessCapture.enabled" = lock-false;
        #   "signon.privateBrowsingCapture.enabled" = lock-false;
        #   "signon.rememberSignons" = lock-false; # Using Bitwarden for this
        #   # "svg.context-properties.content.enabled" = true;
        #   # "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        #   # "trailhead.firstrun.didSeeAboutWelcome" = true;
        #   # "webchannel.allowObject.urlWhitelist" = "";

        #   # # THEME ADJUSTMENTS
        #   # "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        #   # "browser.compactmode.show" = true;
        #   # "browser.uidensity" = 1;
        #   # "browser.display.focus_ring_on_anything" = true;
        #   # "browser.display.focus_ring_style" = 0;
        #   # "browser.display.focus_ring_width" = 0;
        #   # "layout.css.prefers-color-scheme.content-override" = 2;
        # };


        # Things I don't want/need/care
        CaptivePortal = false;
        DisableFirefoxScreenshots = true;
        DisableSetDesktopBackground = true;
        DisplayMenuBar = "default-off";
        DontCheckDefaultBrowser = true;
        EncryptedMediaExtensions = { Enabled = false; };
        FirefoxSuggest = {
          ImproveSuggest = false;
          Locked = true;
          SponsoredSuggestions = false;
          WebSuggestions = false;
        };
        NetworkPrediction = false;
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        PictureInPicture = { Enabled = false; Locked = true; };
        PopupBlocking = {
          Default = true;
          # Allow = [];
        };
        PromptForDownloadLocation = false;
        SearchSuggestEnabled = false;
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
        GenerativeAI = {
          # Enabled = false;
          Locked = true;
        };
      };


      settings = {
        "browser.contentblocking.category" = "strict";
        "browser.dom.window.dump.enabled" = false;
        "browser.safebrowsing.downloads.remote.block_potentially_unwanted" = false;
        "browser.safebrowsing.downloads.remote.block_uncommon" = false;
        "browser.safebrowsing.downloads.remote.enabled" = false;
        # "browser.startup.homepage" = "";

        "network.connectivity-service.enabled" = false;
        "network.prefetch-next" = false;
        
        "privacy.bounceTrackingProtection.mode" = 1;
        "privacy.annotate_channels.strict_list.enabled" = true;
        "privacy.clearOnShutdown_v2.browsingHistoryAndDownloads" = true;
        "privacy.clearOnShutdown_v2.formdata" = true;
        "privacy.clearOnShutdown_v2.historyFormDataAndDownloads" = true;
        "privacy.fingerprintingProtection" = true;
        "privacy.trackingprotection.emailtracking.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;

        "sidebar.verticalTabs" = true;
        "sidebar.expandOnHover" = true;
        "sidebar.verticalTabs.dragToPinPromo.dismissed" = true;

        "toolkit.telemetry.reportingpolicy.firstRun" = false;
      };


      # Profile (check about:config for options)
      profiles.default = {
        id = 0;
        name = "${osConfig.nouveauxParadigmes.users.main}";
        isDefault = true;
        settings = {
  			};

        bookmarks = {
          force = true;
          settings = bookmarks;
        };

        # settings = {      
        #   # I18n
        #   # ----
        #   "intl.accept_languages" = "en-US, en, fr-BE, fr";
        # };
      };
    };


    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_DBUS_REMOTE = "1";
    };
  };
}
