###############################################################################
#
# So far, it's a one user system. I'll need to reorganize that when
# this changes. I should probably reorganize it anyway though.
#
###############################################################################

{ config, osConfig, lib, inputs, ... }: let
  cfg = osConfig.nouveauxParadigmes;
in
{
  imports = [
    ../../../config     # All the configs for tty and gui apps
    ./impermanence.nix  # Define what should be kept between reboots
    ./programs.nix      # No matter what, we'll always have a tty
    ./secrets.nix       # Agenix files 
  ];


  config = {
    home = {
      file = with config.lib.file; {
        ".face".source = mkOutOfStoreSymlink ../face.jpg;
        "Pictures/Wallpapers".source = mkOutOfStoreSymlink ../wallpapers;
        ".cache/noctalia/wallpapers.json" = let
            wallpaperPath = "${config.home.homeDirectory}/Pictures/Wallpapers/20181014-04-Croptic-Karl_Delandsheere.jpg";
          in {
          text = builtins.toJSON {
            defaultWallpaper = wallpaperPath;
            wallpapers       = { "eDP-1" = wallpaperPath; };
          };
        };
      };


      # @todo 
      shellAliases = {
        tsup-dimeritium = ''
          mullvad disconnect && \
          tailscale up --force-reauth --operator=$USER \
            --login-server=https://headscale.sunflower-cloud.com:8080 \
            --auth-key $(cat /run/agenix/auth/tailscale/dimeritium)
        '';
        tsup-np = ''
          mullvad disconnect && \
          tailscale up --force-reauth --operator=$USER \
            --login-server=https://headscale.nouveaux-paradigmes.be \
            --auth-key $(cat /run/agenix/auth/tailscale/nouveauxparadigmes)
        '';
        tsdown = "tailscale down && mullvad connect";
      };
    };


    accounts.email = {
      # maildirBasePath = "/persist/data/mail";

      accounts."karl_at_delandsheere_be" = {
        primary = true;
        name = "Karl Delandsheere";
        userName = "karl@delandsheere.be";
        realName = "Karl Delandsheere";
        address = "karl@delandsheere.be";
        signature = {
          showSignature = "append";
          # delimiter = "#-- ¯\\_(ツ)_/¯ --#";
          text = ''
            #-- <b>¯\_(ツ)_/¯</b> --#
            <b>Karl Delandsheere</b>
            <a href="https://shotbykarl.be">Photographie</a> / <a href="https://karl.delandsheere.be/webdev/">Développement web & infographie</a> / <a href="https://longrushtranquille.be">Impression 3D</a>
            --
            Liège, Belgique
            Tel/Signal : <a href="tel:+32498139866">+32 498 13 98 66</a>
          '';
        };
        flavor = "migadu.com";
        passwordCommand = "cat /run/agenix/auth/bw | bw get password Mail/karl@delandsheere.be";

        aerc.enable = true;
      };

      accounts."karl_at_nouveaux-paradigmes_be" = {
        name = "Nouveaux paradigmes";
        userName = "karl@nouveaux-paradigmes.be";
        realName = "Karl Delandsheere";
        address = "karl@nouveaux-paradigmes.be";
        signature = {
          showSignature = "append";
          # delimiter = "#-- ¯\\_(ツ)_/¯ --#";
          text = ''
            #-- <b>¯\_(ツ)_/¯</b> --#
            <b>Karl Delandsheere</b>
            <a href="https://shotbykarl.be">Photographie</a> / <a href="https://karl.delandsheere.be/webdev/">Développement web & infographie</a> / <a href="https://longrushtranquille.be">Impression 3D</a>
            --
            Liège, Belgique
            Tel/Signal : <a href="tel:+32498139866">+32 498 13 98 66</a>
          '';
        };
        flavor = "migadu.com";
        passwordCommand = "cat /run/agenix/auth/bw | bw get password Mail/karl@nouveaux-paradigmes.be";

        aerc.enable = true;
      };

      accounts."expo_at_ventrecontent_be" = {
        name = "Expo @ Ventre Content";
        userName = "expo@ventrecontent.be";
        realName = "Ventre Content";
        address = "expo@ventrecontent.be";
        signature = {
          showSignature = "append";
          # delimiter = "#-- ¯\\_(ツ)_/¯ --#";
          text = ''
            --
            <b>Karl pour Ventre Content<a href="https://ventrecontent.be">Ventre Content</a></b>
            --
            Tel/Signal : <a href="tel:+32498139866">+32 498 13 98 66</a>
          '';
        };
        imap.host = "mail.ventrecontent.be";
        smtp.host = "mail.ventrecontent.be";
        passwordCommand = "cat /run/agenix/auth/bw | bw get password Mail/expo@ventrecontent.be";

        aerc.enable = true;
      };
    };


    # Shouldn't it be enough to set it once in the system part of the config?
    # -----------------------------------------------------------------------
    nixpkgs.config.allowUnfree = cfg.allowUnfree;
  };
}
