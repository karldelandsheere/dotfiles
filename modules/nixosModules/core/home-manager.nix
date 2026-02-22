###############################################################################
# 
# Home-manager setup.
#
###############################################################################

{ inputs, self, ... }:
{
  imports = [ inputs.home-manager.flakeModules.home-manager ];

  flake.nixosModules.core = { lib, config, ... }:
  {
    imports = [
      inputs.home-manager.nixosModules.home-manager
    ];
    
    config = {
      home-manager = {
        backupFileExtension = "backup";
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
}
