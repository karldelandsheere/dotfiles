{
  # Need to work
  # @todo Setup aerc and email accounts

  # Nice to have
  # @todo Customize Swaylock
  # @todo Customize Grub
  # @todo Understand why my Airpods Pro can't connect easily
  # @todo BambuStudio and OrcaSlicer are crashing
  # @todo Find a way to make Affinity work
  # @todo Make my workspaces better and find out how to display only the active and not empty ones

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


  # Pkgs and flakes definitions, aka inputs
  # ---------------------------------------
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
  };


  # Definition of the system, aka outputs
  # -------------------------------------
  outputs = inputs@{
    self,
    nixpkgs,
    impermanence,
    home-manager,
    niri,
    ... }: 
  let
    inherit (nixpkgs.lib) nixosSystem lists;

    mkSystemConfig = {
      system,
      modules,
      useImpermanence ? true,
      ... }: nixosSystem
    { 
      inherit system;
      specialArgs = inputs;

      modules = modules ++ [
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useUserPackages     = true;
            users.unnamedplayer = { imports = [ ./home-manager ]; };
            extraSpecialArgs    = { inherit inputs; };
            backupFileExtension = "backup";
          };
        }
      ];
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
      #   useImpermanence = false;
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
