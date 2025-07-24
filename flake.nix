{
  # https://discourse.nixos.org/t/how-to-set-up-cachix-in-flake-based-nixos-config/31781
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://niri.cachix.org"
      "https://cache.garnix.io"
    ];

    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];
  };


  # Pkgs and flakes definitions, aka inputs
  # ---------------------------------------
  inputs = {
    # Core parts of my systems
    nixpkgs.url      = "github:nixos/nixpkgs/nixos-25.05";
    impermanence.url = "github:nix-community/impermanence";
    agenix           = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs"; };
    home-manager     = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs"; };

    # GUI/WM
    niri.url         = "github:sodiboo/niri-flake";

    # Applications
    affinity-nix.url = "github:mrshmllow/affinity-nix";

    # Optional add-ons
    # firefox-addons   = {
    #   url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    #   inputs.nixpkgs.follows = "nixpkgs"; };
  };


  # Definition of the system, aka outputs
  # -------------------------------------
  outputs = inputs@{ self, nixpkgs, ... }: 
  let
    inherit (nixpkgs.lib) nixosSystem lists;

    mkSystemConfig = { system, modules, ... }: nixosSystem
    { 
      inherit system;
      specialArgs = { inherit inputs; };

      modules = with inputs; [
        agenix.nixosModules.default
        home-manager.nixosModules.home-manager
        impermanence.nixosModules.impermanence
      ] ++ modules;
    };
  in
  {
    # Declare the different systems configs
    # -------------------------------------
    nixosConfigurations = {
      # Qemu VM on macOS/UTM
      # --------------------
      # utm = mkSystemConfig {
      #   system  = "aarch64-linux";
      #   modules = [ ./system/hosts/utm ];
      # };

      # bare-metal on amd ryzen
      # -----------------------
      q3dm10 = mkSystemConfig {
        system  = "x86_64-linux";
        modules = [ ./system/hosts/q3dm10 ];
      };

      # Sony Vaio VGN-TX5XN/B
      # - Intel U1500 / 1GB RAM
      # -----------------------
      q3dm11 = mkSystemConfig {
        system = "i686-linux";
        modules = [ ./system/hosts/q3dm11 ];
      };
    };


    # Declare home-manager as stand-alone
    # -----------------------------------
    # homeConfigurations = {
    #   unnamedplayer = home-manager.lib.homeManagerConfiguration {
    #     pkgs = nixpkgs.legacyPackages.x86_64-linux;
    #     modules = [
    #       stylix.homeModules.stylix
    #       ./home-manager
    #     ];
    #     extraSpecialArgs = { inherit inputs; };
    #   };
    # };
  };
}
