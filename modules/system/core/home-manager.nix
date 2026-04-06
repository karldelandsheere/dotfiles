###############################################################################
# 
# Home-manager setup.
#
###############################################################################

{ inputs, self, ... }:
{
  imports = [ inputs.home-manager.flakeModules.home-manager ];

  flake.modules = {
    nixos.core = { config, lib, ... }: {
      imports = [
        inputs.home-manager.nixosModules.home-manager
      ];
    
      config = {
        home-manager = {
          backupCommand = "trash";
          # backupFileExtension = "backup";
          extraSpecialArgs = { inherit inputs; };
          useUserPackages = true;

          sharedModules = [
            {
              programs.home-manager.enable = true;
              home.stateVersion = config.system.stateVersion;
              news.display = "show";
            }
          ] ++ lib.lists.optionals config.features.desktop.enable [
            self.homeModules.desktop
          ];
        };
      };
    };

    darwin.core = { config, ... }: {
      imports = [
        inputs.home-manager.darwinModules.home-manager
      ];

      config = {
        home-manager = {
          extraSpecialArgs = { inherit inputs; };
          useUserPackages = true;

          sharedModules = [
            {
              programs.home-manager.enable = true;
              home.stateVersion = config.system.stateVersion;
            }

            # self.homeModules.desktop
          ];
        };
      };
    };

  };
}
