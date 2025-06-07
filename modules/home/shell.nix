{ ... }:

{
  # ---- Shell
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      dots = "cd /etc/nixos/";
    };

    profileExtra = ''
      if uwsm check may-start; then
        exec uwsm start -S hyprland-uwsm.desktop
      fi
    '';
  };
}
