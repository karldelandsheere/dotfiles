###############################################################################
#
# Unnamedplayer (that's me), I'm the main user on this system.
#
###############################################################################

{ inputs, self, ... }: let
  username = "unnamedplayer";
  homeDirectory = "/home/${username}";
in
{
  flake.nixosModules.${username} = { lib, config, ... }: let
    cfg = config.nouveauxParadigmes;
  in
  {
    config = {
      users.users.${username} = {
        uid = 1312;
        name = username;
        home = homeDirectory;
        
        extraGroups = [ "wheel" "audio" "input" "networkmanager" "plugdev" "video" ];
        hashedPassword = "$6$BPe.Id8lkpUDdr7Y$HFyDyxc7Bd3uV1Gvx7DhlMEUfPRbHawID5MOuv9XkU7hASw3pG.XgPySR.CEYDGSvh0zdFNLwnB2QlmHBalaC1";
        isNormalUser = true;
      };

      home-manager.users.${username} = {
        imports = [ self.homeModules.${username} ];
        
        home = {
          username = username;
          homeDirectory = homeDirectory;
        };
      };
    };
  };

  # flake.homeModules.${username} = import ../../../../users/unnamedplayer/modules/home-manager.nix;
  flake.homeModules.${username} = { config, pkgs, osConfig, lib, inputs, ... }: let
    cfg = osConfig.nouveauxParadigmes;
  in
  {
    imports = [
      ../../../../config     # All the configs for tty and gui apps
      ../../../../users/unnamedplayer/modules/impermanence.nix  # Define what should be kept between reboots
      ../../../../users/unnamedplayer/modules/programs.nix      # No matter what, we'll always have a tty
      ../../../../users/unnamedplayer/modules/secrets.nix       # Agenix files
      ../../../../users/unnamedplayer/modules/mail.nix          # Mail
    ];

    config = {
      home = {
        shellAliases = {
          todo = "clear && grep -rnw ${cfg.dotfiles} --exclude-dir=__unused_or_deprecated -e '@todo'";

          tsup-dimeritium = ''
            mullvad disconnect && \
            tailscale up --force-reauth --operator=$USER \
              --login-server=https://headscale.sunflower-cloud.com:8080 \
              --auth-key $(cat /run/agenix/auth/tailscale/dimeritium)                                                                 '';
          tsup-np = ''
            mullvad disconnect && \                                                                                                     tailscale up --force-reauth --operator=$USER \
              --login-server=https://headscale.nouveaux-paradigmes.be \
              --auth-key $(cat /run/agenix/auth/tailscale/nouveauxparadigmes)                                                         '';
          tsdown = "tailscale down --accept-risk=all && mullvad connect";
        };

        file = with config.lib.file; {
          ".face".source = mkOutOfStoreSymlink ../../../../users/unnamedplayer/face.jpg;
          "Pictures/Wallpapers".source = mkOutOfStoreSymlink ../../../../users/unnamedplayer/wallpapers;
          ".cache/noctalia/wallpapers.json" = let
              wallpaperPath = "${config.home.homeDirectory}/Pictures/Wallpapers/20181014-04-Croptic-Karl_Delandsheere.jpg";
          in
          {
            text = builtins.toJSON {
              defaultWallpaper = wallpaperPath;
              wallpapers = { "eDP-1" = wallpaperPath; };
            };
          };
        };
      };

      nixpkgs.config.allowUnfree = cfg.allowUnfree;
    };
  };
}
