# Firefox
# -------

# @todo make the extensions to be activated from the start
# @todo also, check if it's possible to pre-populate some bitwarden info

{ config, pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    languagePacks = [ "en-US" "fr" ];

    # https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265/16
    # ------------------------------------------------------------------------------

    /* ---- POLICIES ---- */
    # Check about:policies#documentation for options.
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value= true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DisablePocket = true;
      DisableFirefoxAccounts = true;
      DisableAccounts = true;
      DisableFirefoxScreenshots = true;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      DontCheckDefaultBrowser = true;
      DisplayBookmarksToolbar = "always";
      DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
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
        # Disable those f***ers
        # ---------------------
        "extensions.pocket.enabled" = lock-false;

        "extensions.screenshots.disabled" = lock-true;
        "browser.topsites.contile.enabled" = lock-false;
        "browser.formfill.enable" = lock-false;
        "browser.search.suggest.enabled" = lock-false;
        "browser.search.suggest.enabled.private" = lock-false;
        "browser.urlbar.suggest.searches" = lock-false;
        "browser.urlbar.showSearchSuggestionsFirst" = lock-false;
        "browser.newtabpage.activity-stream.feeds.topsites" = lock-false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = lock-false;
        "browser.newtabpage.activity-stream.feeds.snippets" = lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includeVisited" = lock-false;
        "browser.newtabpage.activity-stream.showSponsored" = lock-false;
        "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
        
        # Security
        # --------
        "dom.security.https_first" = true;
        "dom.security.sanitizer.enabled" = true;
        "security.mixed_content.block_display_content" = true;
        "security.mixed_content.upgrade_display_content" = true;
        "security.mixed_content.upgrade_display_content.image" = true;

        # Don't prefetch stuff for nothing
        # --------------------------------
        "network.dns.disablePrefetch" = lock-true;
        "network.prefetch-next" = lock-false;
        "network.predictor.enabled" = lock-false;


        # No autofills for sensitive data
        # -------------------------------
        # "extensions.formautofill.addresses.enabled" = false;
        "extensions.formautofill.creditCards.enabled" = lock-false;

        # Opt-out from telemetry, reporting, etc.
        # ---------------------------------------
        "datareporting.policy.dataSubmissionEnabled" = lock-false;
        "datareporting.healthreport.uploadEnabled" = lock-false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.enabled" = lock-false;
        "toolkit.telemetry.server" = "data:,";
        "toolkit.telemetry.archive.enabled" = lock-false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.updatePing.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "toolkit.telemetry.coverage.opt-out" = true;
        "toolkit.coverage.opt-out" = true;
        "toolkit.coverage.endpoint.base" = "";
        "browser.ping-centre.telemetry" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        "breakpad.reportURL" = "";
        "browser.tabs.crashReporting.sendReport" = false;
        "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
        "app.shield.optoutstudies.enabled" = false;
        "app.normandy.enabled" = false;
        "app.normandy.api_url" = "";

        # Mitigate tracking
        # -----------------
        "browser.contentblocking.category" = { Value = "strict"; Status = "locked"; };
        "urlclassifier.trackingSkipURLs" = "*.reddit.com, *.twitter.com, *.twimg.com, *.tiktok.com";
        "urlclassifier.features.socialtracking.skipURLs" = "*.instagram.com, *.twitter.com, *.twimg.com";
        "network.cookie.sameSite.noneRequiresSecure" = true;
        "browser.download.start_downloads_in_tmp_dir" = true;
        "browser.helperApps.deleteTempFileOnExit" = true;
        "browser.uitour.enabled" = false;
        "privacy.globalprivacycontrol.enabled" = true;
        "privacy.globalprivacycontrol.functionality.enabled" = true;

        # More privacy stuff
        # ------------------
        "network.http.referer.XOriginTrimmingPolicy" = 2;

        # Passwords
        # ---------
        "signon.rememberSignons" = lock-false;
        "signon.formlessCapture.enabled" = lock-false;
        "signon.privateBrowsingCapture.enabled" = lock-false;
        # "network.auth.subresource-http-auth-allow" = 1;
        # "editor.truncate_user_pastes" = false;

        # Downloads preferences
        # ---------------------
        "browser.download.useDownloadDir" = false;
        "browser.download.always_ask_before_handling_new_types" = true;
        "browser.download.manager.addToRecentDocs" = false;
        "browser.download.open_pdf_attachments_inline" = true;

        # And shut the fuck up
        # --------------------
        "browser.aboutwelcome.enabled" = false;
        "browser.urlbar.trending.featureGate" = false;
        "browser.preferences.moreFromMozilla" = false;
        "browser.aboutConfig.showWarning" = false;
        "browser.discovery.enabled" = false;
        "browser.shell.checkDefaultBrowser" = false;
        "extensions.getAddons.showPane" = false;
        "extensions.htmlaboutaddons.recommendations.enabled" = false;


        # # NETWORK
        # "network.buffer.cache.size" = 262144;
        # "network.buffer.cache.count" = 128;
        # "network.http.max-connections" = 1800;
        # "network.http.max-persistent-connections-per-server" = 10;
        # "network.http.max-urgent-start-excessive-connections-per-host" = 5;
        # "network.http.pacing.requests.enabled" = false;
        # "network.dnsCacheExpiration" = 3600;
        # "network.dns.max_high_priority_threads" = 8;
        # "network.ssl_tokens_cache_capacity" = 10240;
        # # OCSP & CERTS / HPKP
        # "security.OCSP.enabled" = 0;
        # "security.remote_settings.crlite_filters.enabled" = true;
        # "security.pki.crlite_mode" = 2;
        # # SSL / TLS
        # "security.ssl.treat_unsafe_negotiation_as_broken" = true;
        # "browser.xul.error_pages.expert_bad_cert" = true;
        # "security.tls.enable_0rtt_data" = false;
        # # DISK AVOIDANCE
        # "browser.privatebrowsing.forceMediaMemoryCache" = true;
        # "browser.sessionstore.interval" = 60000;
        # # SHUTDOWN & SANITIZING
        # "privacy.history.custom" = true;
        # # SEARCH / URL BAR
        # "browser.search.separatePrivateDefault.ui.enabled" = true;
        # "browser.urlbar.update2.engineAliasRefresh" = true;
        # "browser.search.suggest.enabled" = false;
        # "browser.urlbar.suggest.quicksuggest.sponsored" = false;
        # "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
        # "browser.formfill.enable" = false;
        # "security.insecure_connection_text.enabled" = true;
        # "security.insecure_connection_text.pbmode.enabled" = true;
        # "network.IDN_show_punycode" = true;
        # # MIXED CONTENT + CROSS-SITE
        # "pdfjs.enableScripting" = false;
        # "extensions.postDownloadThirdPartyPrompt" = false;
        # # CONTAINERS
        # "privacy.userContext.ui.enabled" = true;
        # # WEBRTC
        # "media.peerconnection.ice.proxy_only_if_behind_proxy" = true;
        # "media.peerconnection.ice.default_address_only" = true;
        # # SAFE BROWSING
        # "browser.safebrowsing.downloads.remote.enabled" = false;
        # # MOZILLA
        # "permissions.default.desktop-notification" = 2;
        # "permissions.default.geo" = 2;
        # "geo.provider.network.url" = "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%";
        # "permissions.manager.defaultsUrl" = "";
        # "webchannel.allowObject.urlWhitelist" = "";
        # # DETECTION
        # "captivedetect.canonicalURL" = "";
        # "network.captive-portal-service.enabled" = false;
        # "network.connectivity-service.enabled" = false;
        # # MOZILLA UI
        # "browser.privatebrowsing.vpnpromourl" = "";
        # "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
        # "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
        # "browser.tabs.tabmanager.enabled" = false;

        # # THEME ADJUSTMENTS
        # "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        # "browser.compactmode.show" = true;
        # "browser.display.focus_ring_on_anything" = true;
        # "browser.display.focus_ring_style" = 0;
        # "browser.display.focus_ring_width" = 0;
        # "layout.css.prefers-color-scheme.content-override" = 2;
        # "browser.privateWindowSeparation.enabled" = false; # WINDOWS
        # # COOKIE BANNER HANDLING
        # "cookiebanners.service.mode" = 1;
        # "cookiebanners.service.mode.privateBrowsing" = 1;
        # "cookiebanners.service.enableGlobalRules" = true;

        # # URL BAR
        # "browser.urlbar.suggest.calculator" = true;
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
    BROWSER = "firefox";
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_DBUS_REMOTE = "1";
  };

  xdg.mimeApps.defaultApplications = {
		"application/xhtml+xml" = "firefox.desktop";
		"text/html" = "firefox.desktop";
		"text/xml" = "firefox.desktop";
		"x-scheme-handler/http" = "firefox.desktop";
		"x-scheme-handler/https" = "firefox.desktop";
  };
}
