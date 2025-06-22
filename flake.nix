{
  # @todo Figure out impermanence (fs is ok though)
  # @todo Swayidle is not functionning
  # @todo Setup Tailscale
  # @todo Setup aerc and email accounts
  # @todo What's Polkit anyway?
  # @todo Understand why my Airpods Pro can't connect easily
  # @todo BambuStudio and OrcaSlicer are crashing
  # @todo Find a way to make Affinity work
  # @todo Make my workspaces better and find out how to display only the active and not empty ones
  # @todo Customize Swaylock
  # @todo Customize Grub

  # https://discourse.nixos.org/t/how-to-set-up-cachix-in-flake-based-nixos-config/31781
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://niri.cachix.org"
    ];

    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
    ];
  };


  inputs = {
    nixpkgs.url      = "github:nixos/nixpkgs/nixos-25.05";
    impermanence.url = "github:nix-community/impermanence";
    niri.url         = "github:sodiboo/niri-flake";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # https://github.com/mrshmllow/affinity-nix
    # affinity-nix.url = "github:mrshmllow/affinity-nix";
  };


  outputs = inputs@{ self, nixpkgs, impermanence, home-manager, niri, ... }: 
  let
    inherit (nixpkgs.lib) nixosSystem lists;

    mkSystemConfig = { system, modules, useHomeManager ? true, ... }: nixosSystem
    { 
      inherit system;
      specialArgs = inputs;

      modules = modules ++ [
        inputs.impermanence.nixosModules.impermanence
      # ] ++ lists.optionals (useHomeManager) [
      #   home-manager.nixosModules.home-manager
      #   {
      #     home-manager = {
      #       useGlobalPkgs = true;
      #       useUserPackages = true;
      #       users.unnamedplayer = { imports = [ ./home-manager ]; };
      #       extraSpecialArgs = { inherit system inputs; };
      #     };
      #   }
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

    homeConfigurations = {
      unnamedplayer = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [ ./home-manager ];
        extraSpecialArgs = { inherit inputs; };
      };
    };
  };
}
