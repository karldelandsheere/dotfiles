{ pkgs, ... }:

{
  # ---- Terminal
  programs = {
    # ghostty.enable = true;
    terminator.enable = true;

    helix = {
      enable = true;
      defaultEditor = true;
    };
  };

  home.packages = [ pkgs.scooter ];
}
