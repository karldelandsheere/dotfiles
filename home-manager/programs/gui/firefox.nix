{ pkgs, inputs, ... }:
{
  # Firefox
  # -------

  # @todo make the extensions to be activated from the start
  # @todo also, check if it's possible to pre-populate some bitwarden info

  programs.firefox = {
    enable = true;

    profiles.default = {
      id = 0;
      name = "unnamedplayer";

      extensions.packages = with inputs.firefox-addons.packages.${pkgs.system}; [
        bitwarden
        ublock-origin
      ];
      
      # search.engines = {
      #   Bing.metaData.hidden = true;
      #   "Amazon.com".metaData.hidden = true;
      #   "Wikipedia (en)".metaData.hidden = true;
      #   "Google".metaData.alias = "@g";
      # };
      
      settings = {      
        # I18n
        # ----
        "intl.accept_languages" = "en-US, en, fr-BE, fr";

        # Enable my extensions
        # --------------------
        "extensions.bitwarden.enabled" = true;
        "extensions.ublock-origin.enabled" = true;

        # Security
        # --------
        "dom.security.https_first" = true;
        "dom.security.sanitizer.enabled" = true;
        "security.mixed_content.block_display_content" = true;
        "security.mixed_content.upgrade_display_content" = true;
        "security.mixed_content.upgrade_display_content.image" = true;

        # Don't prefetch stuff for nothing
        # --------------------------------
        "network.dns.disablePrefetch" = true;
        "network.prefetch-next" = false;
        "network.predictor.enabled" = false;

        # Disable those f***ers
        # ---------------------
        "extensions.pocket.enabled" = false;

        # No autofills for sensitive data
        # -------------------------------
        # "extensions.formautofill.addresses.enabled" = false;
        "extensions.formautofill.creditCards.enabled" = false;

        # Opt-out from telemetry, reporting, etc.
        # ---------------------------------------
        "datareporting.policy.dataSubmissionEnabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.server" = "data:,";
        "toolkit.telemetry.archive.enabled" = false;
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
        "browser.contentblocking.category" = "strict";
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

        # Downloads preferences
        # ---------------------
        "browser.download.useDownloadDir" = false;
        "browser.download.always_ask_before_handling_new_types" = true;
        "browser.download.manager.addToRecentDocs" = false;
        "browser.download.open_pdf_attachments_inline" = true;

        # And shut the fuck up
        # --------------------
        "browser.aboutwelcome.enabled" = false;

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
        # # PASSWORDS
        # "signon.rememberSignons" = false;
        # "signon.formlessCapture.enabled" = false;
        # "signon.privateBrowsingCapture.enabled" = false;
        # "network.auth.subresource-http-auth-allow" = 1;
        # "editor.truncate_user_pastes" = false;
        # # MIXED CONTENT + CROSS-SITE
        # "pdfjs.enableScripting" = false;
        # "extensions.postDownloadThirdPartyPrompt" = false;
        # # HEADERS / REFERERS
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
        # "extensions.getAddons.showPane" = false;
        # "extensions.htmlaboutaddons.recommendations.enabled" = false;
        # "browser.discovery.enabled" = false;
        # "browser.shell.checkDefaultBrowser" = false;
        # "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
        # "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
        # "browser.preferences.moreFromMozilla" = false;
        # "browser.tabs.tabmanager.enabled" = false;
        # "browser.aboutConfig.showWarning" = false;
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
        # "browser.urlbar.trending.featureGate" = false;
        # # NEW TAB PAGE
        # "browser.newtabpage.activity-stream.feeds.topsites" = false;
        # "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
      };
    };
  };

  home.sessionVariables.BROWSER = "firefox";
}
