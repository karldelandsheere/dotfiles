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
  flake.nixosModules.${username} = { lib, config, ... }:
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

  flake.homeModules.${username} = { config, pkgs, osConfig, lib, ... }:
  {
    config = {
      home.file = with config.lib.file; {
        ".face".source = mkOutOfStoreSymlink ./profile.jpg;
        ".wallpaper".source = mkOutOfStoreSymlink ./20181014-04-Croptic-Karl_Delandsheere.jpg;
        ".cache/noctalia/wallpapers.json" = let
            wallpaperPath = "${config.home.homeDirectory}/.wallpaper";
        in
        {
          text = builtins.toJSON {
            defaultWallpaper = wallpaperPath;
            wallpapers = { "eDP-1" = wallpaperPath; };
          };
        };
      };

      age.secrets = { # @todo Auto discover and add those, and move out of the repo
        "auth/bw".file = ./secrets/auth/bw.age;
        "auth/mail/karl_at_delandsheere_be".file = ./secrets/auth/mail/karl_at_delandsheere_be.age;
        "auth/mail/karl_at_nouveaux-paradigmes_be".file = ./secrets/auth/mail/karl_at_nouveaux-paradigmes_be.age;
        "auth/matrix/dimeritium".file = ./secrets/auth/matrix/dimeritium.age;
        "auth/tailscale/dimeritium".file = ./secrets/auth/tailscale/dimeritium.age;
      };

      nixpkgs.config.allowUnfree = osConfig.nixpkgs.config.allowUnfree;
    };
  };
}
