###############################################################################
# 
# Home-manager setup.
#
# Next steps:
#   - @todo Figure out what should be moved to Home-Manager instead of
#       system, in terms of packages, programs, and stuff.
#
###############################################################################

{ inputs, self, ... }:
{
  imports = [ inputs.home-manager.flakeModules.home-manager ];

  flake.nixosModules.core = { lib, config, ... }: let
    cfg = config.nouveauxParadigmes;
  in
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

          inputs.agenix.homeManagerModules.default

        ] ++ lib.lists.optionals ( cfg.gui.enable ) [
          self.homeModules.desktop
        ];
      };
    };
  };

#   flake.homeModules.common = {
#     default = {
      
#     };
#   };
}


