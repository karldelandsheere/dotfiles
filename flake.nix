#############################################################################
#
# Welcome to my dotfiles. This is a work in progress. Enjoy the ride!
# Git repo: https://github.com/karldelandsheere/dotfiles/
#
# Tips and feedback welcome!
# 
# Next steps:
# -----------
#   - @todo Adapt the shell scripts under system/scripts to reflect the mods
#   - @todo Make Affinity Designer work
#   - @todo Implement a local binary cache to speed up rebuild a bit
#   - @todo Move what is related to my user away from the system's config
#   - @todo Actually use this setup for something else than ricing...
# 
#############################################################################

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
    nixpkgs.url      = "github:nixos/nixpkgs/nixos-25.11";
    impermanence.url = "github:nix-community/impermanence";
    agenix           = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs"; };
    home-manager     = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs"; };

    # GUI/WM
    niri.url         = "github:sodiboo/niri-flake";
    noctalia         = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs"; };

    # Programs
    # globalprotect-openconnect.url = "github:yuezk/GlobalProtect-openconnect";
    # affinity-nix.url = "github:mrshmllow/affinity-nix"; # Not working "Unable to find runtime blablabla"
  };


  # @todo OK, so why don't I separate nixos and home-manager so
  # I could just rebuild hm without the whole setup?
  # Also, wouldn't it be more versatile?
  # And couldn't I read the hosts dir and load the configurations dynamically?


  # Definition of the system (outputs)
  outputs = inputs@{ self, nixpkgs, ... }: let
    inherit (nixpkgs.lib) nixosSystem mapAttrs;

    mkSystemConfig = { hostname, system,
                       modules ? [], users ? [], ... }: nixosSystem
    { 
      inherit system;
      modules = [ ./hosts/${hostname} ] ++ modules;

      specialArgs = {
        inherit inputs;
        users = [ "unnamedplayer" ] ++ users;
      };
    };
  in
  {
    # Declare the different hosts configs
    nixosConfigurations = mapAttrs (hostname: config:
      mkSystemConfig ( { inherit hostname; } // config ) )
      {
        "q3dm10" = { system = "x86_64-linux"; };
        "q3dm11" = { system = "i686-linux"; };
        "utm"    = { };
      };
  };
}
