# Firefox
# -------
# @todo make the extensions to be activated from the start
# @todo also, check if it's possible to pre-populate some bitwarden info
{ config, pkgs, ... }:
{
  config = {
    programs.firefox = {
      enable = true;
      languagePacks = [ "en-US" "fr" ];

      # https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265/16
      # ------------------------------------------------------------------------------

      /* ---- POLICIES ---- */
      # Check about:policies#documentation for options.
      policies = {
        # Right now, I'm still using my account
        # When ready, I'll ditch it
        # DisableAccounts = true;
        # DisableFirefoxAccounts = true;

        # Ordered by alphabetical order        
        CaptivePortal = false;
        DisplayBookmarksToolbar = "always";
        DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
        DisableBuiltinPDFViewer = true;
        DisableFirefoxScreenshots = true;
        DisableFirefoxStudies = true;
        DisableFormHistory = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DNSOverHTTPS = {
          Enabled = false;
        };
        DontCheckDefaultBrowser = true;
        EnableTrackingProtection = {
          Value= true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        NetworkPrediction = false;
        NewTabPage = false;
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        SearchBar = "unified"; # alternative: "separate"


        /* ---- EXTENSIONS ---- */
        # To add additional extensions, find it on addons.mozilla.org, find
        # the short ID in the url (like https://addons.mozilla.org/en-US/firefox/addon/!SHORT_ID!/)
        # Then, download the XPI by filling it in to the install_url template, unzip it,
        # run `jq .browser_specific_settings.gecko.id manifest.json` or
        # `jq .applications.gecko.id manifest.json` to get the UUID
        # or
        # Check about:support for extension/add-on ID strings.
        # Valid strings for installation_mode are "allowed", "blocked",
        # "force_installed" and "normal_installed".
        ExtensionSettings = with builtins; let
          extension = shortId: uuid: {
            name = uuid;
            value = {
              install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
              installation_mode = "normal_installed";
            };
          };
        in listToAttrs [
          (extension "bitwarden-password-manager" "{446900e4-71c2-419f-a6a7-df9c091e268b}")
          (extension "ublock-origin" "uBlock0@raymondhill.net")
          (extension "clearurls" "{74145f27-f039-47ce-a470-a662b129930a}")
          (extension "canvasblocker" "CanvasBlocker@kkapsner.de")
          (extension "privacy-badger17" "jid1-MnnxcxisBPnSXQ@jetpack")
        ];


        /* ---- PREFERENCES ---- */
        # Check about:config for options.
        Preferences = let
          lock-false = {
            Value = false;
            Status = "locked";
          };
          lock-true = {
            Value = true;
            Status = "locked";
          };
        in {

          "app.normandy.api_url" = "";
          "app.normandy.enabled" = lock-false;
          "app.shield.optoutstudies.enabled" = lock-false;
          "app.update.auto" = lock-false;
          "beacon.enabled" = lock-false;
          "breakpad.reportURL" = "";
          "browser.aboutConfig.showWarning" = lock-false;
          "browser.aboutwelcome.enabled" = lock-false;
          "browser.cache.offline.enable" = lock-false;
          "browser.contentblocking.category" = { Value = "strict"; Status = "locked"; };
          "browser.crashReports.unsubmittedCheck.autoSubmit" = lock-false;
          "browser.crashReports.unsubmittedCheck.autoSubmit2" = lock-false;
          "browser.crashReports.unsubmittedCheck.enabled" = lock-false;
          "browser.disableResetPrompt" = lock-true;
          "browser.discovery.enabled" = lock-false;
          "browser.download.always_ask_before_handling_new_types" = lock-true;
          "browser.download.manager.addToRecentDocs" = lock-false;
          "browser.download.open_pdf_attachments_inline" = lock-true;
          "browser.download.start_downloads_in_tmp_dir" = true;
          "browser.download.useDownloadDir" = false;
          "browser.fixup.alternate.enabled" = lock-false;
          "browser.formfill.enable" = lock-false;
          "browser.helperApps.deleteTempFileOnExit" = lock-true;
          "browser.newtab.preload" = lock-false;
          # "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
          # "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = lock-false;
          "browser.newtabpage.activity-stream.feeds.snippets" = lock-false;
          "browser.newtabpage.activity-stream.feeds.telemetry" = lock-false;
          "browser.newtabpage.activity-stream.feeds.topsites" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeVisited" = lock-false;
          "browser.newtabpage.activity-stream.showSponsored" = lock-false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
          "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
          "browser.newtabpage.activity-stream.telemetry" = lock-false;
          "browser.newtabpage.enabled" = lock-false;
          "browser.newtabpage.enhanced" = lock-false;
          "browser.newtabpage.introShown" = lock-true;
          "browser.ping-centre.telemetry" = lock-false;
          "browser.preferences.moreFromMozilla" = lock-false;
          # "browser.privatebrowsing.forceMediaMemoryCache" = true;
          # "browser.privatebrowsing.vpnpromourl" = "";
          "browser.safebrowsing.appRepURL" = "";
          "browser.safebrowsing.blockedURIs.enabled" = lock-false;
          "browser.safebrowsing.downloads.enabled" = lock-false;
          "browser.safebrowsing.downloads.remote.enabled" = lock-false;
          "browser.safebrowsing.downloads.remote.url" = "";
          "browser.safebrowsing.enabled" = lock-false;
          "browser.safebrowsing.malware.enabled" = lock-false;
          "browser.safebrowsing.phishing.enabled" = lock-false;
          # "browser.search.separatePrivateDefault.ui.enabled" = true;
          "browser.search.suggest.enabled" = lock-false;
          "browser.search.suggest.enabled.private" = lock-false;
          "browser.selfsupport.url" = "";
          "browser.send_pings" = lock-false;
          "browser.sessionstore.interval" = 60000;
          "browser.sessionstore.privacy_level" = 0;
          "browser.shell.checkDefaultBrowser" = lock-false;
          "browser.startup.homepage_override.mstone" = "ignore";
          "browser.tabs.crashReporting.sendReport" = lock-false;
          # "browser.tabs.tabmanager.enabled" = false;
          "browser.topsites.contile.enabled" = lock-false;
          "browser.uitour.enabled" = lock-false;
          "browser.urlbar.groupLabels.enabled" = lock-false;
          "browser.urlbar.quicksuggest.enabled" = lock-false;
          "browser.urlbar.showSearchSuggestionsFirst" = lock-false;
          "browser.urlbar.speculativeConnect.enabled" = lock-false;
          # "browser.urlbar.suggest.calculator" = true;
          # "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
          # "browser.urlbar.suggest.quicksuggest.sponsored" = false;
          "browser.urlbar.suggest.searches" = lock-false;
          "browser.urlbar.trending.featureGate" = lock-false;
          "browser.urlbar.trimURLs" = lock-false;
          # "browser.urlbar.update2.engineAliasRefresh" = true;
          # "browser.xul.error_pages.expert_bad_cert" = true;
          # "captivedetect.canonicalURL" = "";
          # "cookiebanners.service.enableGlobalRules" = true;
          # "cookiebanners.service.mode" = 1;
          # "cookiebanners.service.mode.privateBrowsing" = 1;
          "datareporting.healthreport.service.enabled" = lock-false;
          "datareporting.healthreport.uploadEnabled" = lock-false;
          "datareporting.policy.dataSubmissionEnabled" = lock-false;
          "device.sensors.ambientLight.enabled" = lock-false;
          "device.sensors.enabled" = lock-false;
          "device.sensors.motion.enabled" = lock-false;
          "device.sensors.orientation.enabled" = lock-false;
          "device.sensors.proximity.enabled" = lock-false;
          "dom.battery.enabled" = lock-false;
          "dom.event.clipboardevents.enabled" = lock-false;
          "dom.private-attribution.submission.enabled" = lock-false;
          "dom.security.https_first" = true;
          "dom.security.sanitizer.enabled" = true;
          "dom.webaudio.enabled" = lock-false;
          # "editor.truncate_user_pastes" = false;
          "experiments.activeExperiment" = lock-false;
          "experiments.enabled" = lock-false;
          "experiments.manifest.uri" = "";
          "experiments.supported" = lock-false;
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
          # "geo.provider.network.url" = "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%";
          "keyword.enabled" = lock-false;
          "media.autoplay.default" = 1;
          "media.autoplay.enabled" = lock-false;
          "media.eme.enabled" = lock-false;
          "media.gmp-widevinecdm.enabled" = lock-false;
          "media.navigator.enabled" = lock-false;
          "media.peerconnection.enabled" = lock-false;
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
          "privacy.donottrackheader.enabled" = lock-true;
          "privacy.donottrackheader.value" = 1;
          "privacy.firstparty.isolate" = lock-true;
          "privacy.globalprivacycontrol.enabled" = lock-true;
          "privacy.globalprivacycontrol.functionality.enabled" = lock-true;
          # "privacy.history.custom" = true;
          "privacy.query_stripping" = lock-true;
          "privacy.resistFingerprinting" = lock-true;
          "privacy.trackingprotection.cryptomining.enabled" = lock-true;
          "privacy.trackingprotection.enabled" = lock-true;
          "privacy.trackingprotection.fingerprinting.enabled" = lock-true;
          "privacy.trackingprotection.pbmode.enabled" = lock-true;
          "privacy.usercontext.about_newtab_segregation.enabled" = lock-true;
          # "privacy.userContext.ui.enabled" = true;
          "security.mixed_content.block_display_content" = true;
          "security.mixed_content.upgrade_display_content" = true;
          "security.mixed_content.upgrade_display_content.image" = true;
          # "security.OCSP.enabled" = 0;
          # "security.pki.crlite_mode" = 2;
          # "security.remote_settings.crlite_filters.enabled" = true;
          # "security.insecure_connection_text.enabled" = true;
          # "security.insecure_connection_text.pbmode.enabled" = true;
          "security.ssl.disable_session_identifiers" = lock-true;
          # "security.ssl.treat_unsafe_negotiation_as_broken" = true;
          # "security.tls.enable_0rtt_data" = false;
          "services.sync.prefs.sync.browser.newtabpage.activity-stream.showSponsoredTopSite" = lock-false;
          "signon.autofillForms" = lock-false;
          "signon.formlessCapture.enabled" = lock-false;
          "signon.privateBrowsingCapture.enabled" = lock-false;
          "signon.rememberSignons" = lock-false;
          "toolkit.coverage.opt-out" = lock-true;
          "toolkit.coverage.endpoint.base" = "";
          "toolkit.telemetry.archive.enabled" = lock-false;
          "toolkit.telemetry.bhrPing.enabled" = lock-false;
          "toolkit.telemetry.cachedClientID" = "";
          "toolkit.telemetry.coverage.opt-out" = lock-true;
          "toolkit.telemetry.enabled" = lock-false;
          "toolkit.telemetry.firstShutdownPing.enabled" = lock-false;
          "toolkit.telemetry.hybridContent.enabled" = lock-false;
          "toolkit.telemetry.newProfilePing.enabled" = lock-false;
          "toolkit.telemetry.prompted" = 2;
          "toolkit.telemetry.rejected" = lock-true;
          "toolkit.telemetry.reportingpolicy.firstRun" = lock-false;
          "toolkit.telemetry.server" = "";
          "toolkit.telemetry.shutdownPingSender.enabled" = lock-false;
          "toolkit.telemetry.unified" = lock-false;
          "toolkit.telemetry.unifiedIsOptIn" = lock-false;
          "toolkit.telemetry.updatePing.enabled" = lock-false;
          "urlclassifier.features.socialtracking.skipURLs" = "*.instagram.com, *.twitter.com, *.twimg.com";
          "urlclassifier.trackingSkipURLs" = "*.reddit.com, *.twitter.com, *.twimg.com, *.tiktok.com";
          # "webchannel.allowObject.urlWhitelist" = "";
          "webgl.disabled" = true;
          "webgl.renderer-string-override" = " ";
          "webgl.vendor-string-override" = " ";


          # # THEME ADJUSTMENTS
          # "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          # "browser.compactmode.show" = true;
          # "browser.display.focus_ring_on_anything" = true;
          # "browser.display.focus_ring_style" = 0;
          # "browser.display.focus_ring_width" = 0;
          # "layout.css.prefers-color-scheme.content-override" = 2;
          # "browser.privateWindowSeparation.enabled" = false; # WINDOWS
        };
      };


      profiles.default = {
        id = 0;
        name = "unnamedplayer";
        isDefault = true;
        settings = {
  				"browser.search.defaultenginename" = "DuckDuckGo";
  				"browser.search.order.1" = "DuckDuckGo";

  				# "widget.use-xdg-desktop-portal.file-picker" = 1;
  				# "browser.compactmode.show" = true;
  				# "browser.cache.disk.enable" = false;
  				# "widget.disable-workspace-management" = true;
  				# "browser.toolbars.bookmarks.visibility" = "never";
  				# "ui.key.menuAccessKeyFocuses" = false;
  			};

      
        # search.engines = {
        #   Bing.metaData.hidden = true;
        #   "Amazon.com".metaData.hidden = true;
        #   "Wikipedia (en)".metaData.hidden = true;
        #   "Google".metaData.alias = "@g";
        # };
      
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
