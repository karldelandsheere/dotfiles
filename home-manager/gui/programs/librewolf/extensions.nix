# @todo also, check if it's possible to pre-populate some bitwarden info
{
  # Installed extensions
  # --------------------
  "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
    id = "bitwarden-password-manager";
    installation_mode = "force_installed";
    private_browsing = true;
    settings = {};
    permissions = [
      "activeTab"
      "clipboardWrite"
      "contextMenus"
      "cookies"
      "nativeMessaging"
      "notifications"
      "storage"
      "tabs"
      "webNavigation"
      "webRequest"
      "webRequestBlocking"
      "https://*/*"
      "http://*/*"
      "https://api.github.com/"
      "<all_urls>"
    ];
  };
  
  # "CanvasBlocker@kkapsner.de" = {
  #   id = "canvasblocker";
  #   installation_mode = "normal_installed";
  #   private_browsing = true;
  #   settings = {};
  #   permissions = [
  #     "activeTab"
  #     "tabs"
  #     "storage"
  #     "<all_urls>"
  #   ];
  # };
  
  # "{74145f27-f039-47ce-a470-a662b129930a}" = {
  #   id = "clearurls";
  #   installation_mode = "normal_installed";
  #   private_browsing = true;
  #   settings = { };
  #   permissions = [
  #     "activeTab"
  #     "tabs"
  #     "storage"
  #     "<all_urls>"
  #   ];
  # };
  
  # "gdpr@cavi.au.dk" = {
  #   id = "consent-o-matic";
  #   installation_mode = "normal_installed";
  #   private_browsing = true;
  #   settings = { };
  #   permissions = [
  #     "activeTab"
  #     "tabs"
  #     "storage"
  #     "<all_urls>"
  #   ];
  # };

  # "jid1-MnnxcxisBPnSXQ@jetpack" = {
  #   id = "privacy-badger17";
  #   installation_mode = "normal_installed";
  #   private_browsing = true;
  #   settings = {
  #     selectedFilterLists = [
  #       "user-filters"
  #       "ublock-filters"
  #       "ublock-badware"
  #       "ublock-privacy"
  #       "ublock-unbreak"
  #       "ublock-quick-fixes"
  #       "easylist"
  #       "easyprivacy"
  #       "urlhaus-1"
  #       "plowe-0"
  #     ];
  #   };
  #   permissions = [
  #     "activeTab"
  #     "tabs"
  #     "storage"
  #     "<all_urls>"
  #   ];
  # };
}
