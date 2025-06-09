{
  # https://discourse.nixos.org/t/how-to-set-up-cachix-in-flake-based-nixos-config/31781
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
    ];

    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };


  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    
    impermanence.url = "github:nix-community/impermanence";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };


  outputs = inputs@{ self, nixpkgs, impermanence, home-manager, hyprland, ... }: 
  let
    inherit (nixpkgs.lib) nixosSystem lists;

    mkSystemConfig = { system, modules, useHomeManager ? true, ... }: nixosSystem
    { 
      inherit system;
      specialArgs = inputs;

      modules = modules ++ [
        inputs.impermanence.nixosModules.impermanence
      ] ++ lists.optionals (useHomeManager) [
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.unnamedplayer = { imports = [ ./home-manager ]; };
            extraSpecialArgs = { inherit system inputs; };
          };
        }
      ];
    };
  in
  {
    nixosConfigurations = {
      # Qemu VM on macOS/UTM
      # --------------------
      utm = mkSystemConfig {
        system = "aarch64-linux";
        modules = [ ./system/hosts/utm ];
      };

      # bare-metal on amd ryzen
      # -----------------------
      q3dm10 = mkSystemConfig {
        system = "x86_64-linux";
        modules = [ ./system/hosts/q3dm10 ];
      };
    };
  };
}

