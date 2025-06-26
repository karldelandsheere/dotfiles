{ config, ... }:
{
  config = {
    # Ghostty terminal emulator
    # -------------------------
    programs.ghostty = {
      enable = true;
      enableZshIntegration = true;
    };

    home = {
      file.".config/ghostty".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home-manager/programs/gui/ghostty/config";
    };
  };
}
