{ inputs, ... }:
{
  imports = [
    ./programs
    ./utils
    ./wm

    inputs.impermanence.homeManagerModules.impermanence
  ];


  # It's the least, right?
  # ----------------------     
  programs.home-manager.enable = true;

  home = {
    username = "unnamedplayer";
    homeDirectory = "/home/unnamedplayer";
    stateVersion = "25.05";
  };

  news.display = "show";




  # accounts.email = {
    # maildirBasePath = "/persist/data/mail";

    # accounts = let
      # passwordCommand = account:
      #   "${pkgs.jq}/bin/jq "
    # in {
      # "karl_at_delandsheere" = {
        # primary = true;

        # realName = "Karl Delandsheere";
        # address = "karl@delandsheere.be";

        # Folders?

        # userName = "karl@delandsheere.be";
        # passwordCommand = passwordCommand ""

        # flavor = "migadu.com";      
        # imap = {
        #   host = "imap.migadu.com";
          
        # smtp.host = "smtp.migadu.com";

        # aerc.enable = true;
      # };
    # };
  # };










  # accounts.email = {
  #   # maildirBasePath = "/persist/data/mail";

  #   accounts."karl_at_delandsheere" = {
  #     primary = true;
  #     name = "karl@delandsheere.be"; # ?
  #     userName = "karl@delandsheere.be";
  #     realName = "Karl Delandsheere";
  #     address = "karl@delandsheere.be";
  #     flavor = "migadu.com";      
  #     imap.host = "imap.migadu.com";
  #     smtp.host = "smtp.migadu.com";
  #   };

  #   accounts."karl_at_dimeritium" = {
  #     name = "karl@dimeritium.com"; # ?
  #     userName = "karl@dimeritium.com";
  #     realName = "Karl (Dimeritium)";
  #     address = "karl@dimeritium.com";
  #     flavor = "outlook.office365.com";
  #   };
    
  #   accounts."expo_ventrecontent" = {
  #     name = "expo@ventrecontent.be"; # ?
  #     userName = "expo@ventrecontent.be";
  #     realName = "Ventre Content";
  #     address = "expo@ventrecontent.be";
  #     imap.host = "mail.ventrecontent.be";
  #     smtp.host = "mail.ventrecontent.be";
  #   };
  # };









  home.persistence."/persist/home/unnamedplayer" = {
    directories = [
      "OpenCloud"
      ".ssh"
    ];

    files = [
      
    ];

    allowOther = true;
  };








}
