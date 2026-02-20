#############################################################################
#
# Welcome to my dotfiles. This is a work in progress. Enjoy the ride!
# Git repo: https://github.com/karldelandsheere/dotfiles/
#
# Tips and feedback welcome!
# 
# Current steps:
# --------------
#   - @todo Adapt the shell scripts under system/scripts to reflect the mods
#
# Next steps:
# -----------
#   - @todo Try out nix-init: https://www.youtube.com/shorts/RUszKmnq9y4
#   - @todo Try out specialisation: https://www.youtube.com/shorts/cyX8Imfb0Mg
#   - @todo Figure out Devenv in Nix
#   - @todo Implement a local binary cache to speed up rebuild a bit
#   - @todo Find out why I have this error when resuming from hibernation
#       "BTRFS error: failed to open device
#          for path /dev/mapper/cryptroot with flags 0x3: -16"
# Probably never at this point:
# -----------------------------
#   - Actually use this setup for something else than ricing...
# 
#############################################################################

{
  description = "Hi! These dotfiles are chaotic even for my ADHD.";
  
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

  inputs = {
    # Core
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    agenix = { url = "github:ryantm/agenix";
               inputs.nixpkgs.follows = "nixpkgs"; };
    home-manager = { url = "github:nix-community/home-manager/release-25.11";
                     inputs.nixpkgs.follows = "nixpkgs"; };

    # Features
    impermanence.url = "github:nix-community/impermanence";

    # Desktop
    niri.url = "github:sodiboo/niri-flake";
    noctalia = { url = "github:noctalia-dev/noctalia-shell";
                 inputs.nixpkgs.follows = "nixpkgs"; };
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; }
    ( inputs.import-tree ./modules );
}
