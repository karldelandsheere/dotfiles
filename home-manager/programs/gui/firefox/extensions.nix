# @todo also, check if it's possible to pre-populate some bitwarden info
{
  # Installed extensions
  # --------------------
  bitwarden-password-manager = {
    id = "{446900e4-71c2-419f-a6a7-df9c091e268b}";
    installation_mode = "force_installed";
    private_browsing = true;
    settings = { };
    permissions = [ ];
    #   "activeTab"
    #   "clipboardWrite"
    #   "contextMenus"
    #   "cookies"
    #   "nativeMessaging"
    #   "notifications"
    #   "storage"
    #   "tabs"
    #   "webNavigation"
    #   "webRequest"
    #   "webRequestBlocking"
    #   "https://*/*"
    #   "http://*/*"
    #   "https://api.github.com/"
    #   "<all_urls>"
    # ];
  };
  
  canvasblocker = {
    id = "CanvasBlocker@kkapsner.de";
    installation_mode = "normal_installed";
    private_browsing = true;
    settings = { };
    permissions = [ ];
    #   "activeTab"
    #   "tabs"
    #   "storage"
    #   "<all_urls>"
    # ];
  };
  
  clearurls = {
    id = "{74145f27-f039-47ce-a470-a662b129930a}";
    installation_mode = "normal_installed";
    private_browsing = true;
    settings = { };
    permissions = [
      "activeTab"
      "tabs"
      "storage"
      "<all_urls>"
    ];
  };
  
  consent-o-matic = {
    id = "gdpr@cavi.au.dk";
    installation_mode = "normal_installed";
    private_browsing = true;
    settings = { };
    permissions = [
      "activeTab"
      "tabs"
      "storage"
      "<all_urls>"
    ];
  };
  
  privacy-badger17 = {
    id = "jid1-MnnxcxisBPnSXQ@jetpack";
    installation_mode = "normal_installed";
    private_browsing = true;
    settings = {
      selectedFilterLists = [
        "user-filters"
        "ublock-filters"
        "ublock-badware"
        "ublock-privacy"
        "ublock-unbreak"
        "ublock-quick-fixes"
        "easylist"
        "easyprivacy"
        "urlhaus-1"
        "plowe-0"
      ];
    };
    permissions = [
      "activeTab"
      "tabs"
      "storage"
      "<all_urls>"
    ];
  };
  
  ublock-origin = {
    id = "uBlock0@raymondhill.net";
    installation_mode = "normal_installed";
    private_browsing = true;
    settings = {
      selectedFilterLists = [
        "user-filters"
        "ublock-filters"
        "ublock-badware"
        "ublock-privacy"
        "ublock-quick-fixes"
        "ublock-unbreak"
        "easylist"
        "easyprivacy"
        "adguard-spyware"
        "adguard-spyware-url"
        "block-lan"
        "urlhaus-1"
        "plowe-0"
        "dpollock-0"
        "fanboy-cookiemonster"
        "ublock-cookies-easylist"
        "adguard-cookies"
        "ublock-cookies-adguard"
        "easylist-chat"
        "easylist-newsletters"
        "easylist-notifications"
        "easylist-annoyances"
        "adguard-mobile-app-banners"
        "adguard-other-annoyances"
      ];
    };
    permissions = [
      "activeTab"
      "tabs"
      "storage"
      "<all_urls>"
    ];
  };
}
