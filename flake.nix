{
  description = "This is my life now.";

  # https://discourse.nixos.org/t/how-to-set-up-cachix-in-flake-based-nixos-config/31781
  # use --accept-flake-config when rebuilding
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      # "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      # "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    impermanence.url = "github:nix-community/impermanence";

    # home-manager = {
    #   url = "github:nix-community/home-manager/release-25.05";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # hyprland = {
    #   url = "github:hyprwm/Hyprland";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = inputs:
    let
      flakeContext = {
        inherit inputs;
        dotfiles = ./.;
      };
    in
    {
      nixosConfigurations = {
        utm = import ./hosts/utm flakeContext;
        # q3dm10 = import ./hosts/q3dm10 flakeContext;
      };

      # homeConfigurations = {
      #   unnamedplayer = import ./home/unnamedplayer.nix flakeContext;
      # };
    };
}

