{ pkgs, ... }:
{
  # ---- Shell
  programs = {
    zsh = {
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

    helix = {
      enable = true;
      defaultEditor = true;
    };
  };


  home.packages = [ pkgs.scooter ];
}


# if [ -f /etc/nixos/post-install.sh ]; then
#   echo "You need to exec the post-install script. Just this once."
#   echo "---------------------------------------------------------"
#   echo "$ sudo ./post-install.sh"
#   echo "Then, exit and login again."
# else
# fi
