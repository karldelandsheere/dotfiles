# I use zsh because I'm edgy but not too much
# -------------------------------------------
{ config, ... }:
{
  config = {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
    };
  };
}


# if [ -f /etc/nixos/post-install.sh ]; then
#   echo "You need to exec the post-install script. Just this once."
#   echo "---------------------------------------------------------"
#   echo "$ sudo ./post-install.sh"
#   echo "Then, exit and login again."
# else
# fi
