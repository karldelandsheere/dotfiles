###############################################################################
#
# Unnamedplayer (that's me), shell config.
#
###############################################################################

{ inputs, self, ... }: let
  username = "unnamedplayer";
in
{
  flake.homeModules.${username} = { config, pkgs, osConfig, lib, inputs, ... }: let
    cfg = osConfig.nouveauxParadigmes;
  in
  {
    imports = [
      self.homeModules.bottom
      self.homeModules.fastfetch
      self.homeModules.git
      self.homeModules.helix
      self.homeModules.yazi
    ];
    
    config = {
      home = {
        packages = ( with pkgs; [
          cmatrix                # Yeah, I know... like the cool kids
          curl
          exiftool
          ffmpeg
          progress               # Follow the progression of any command
          pure-prompt            # Still on the fence with this one
          scooter                # Directory wide search & replace
          tmux                   # Terminal multiplexer
          tree                   # Kinda ls but as a tree
          ueberzugpp             # Terminal image viewer (needed for yazi)
          yt-dlp                 # Youtube downloader
        ] );

        shellAliases = {
          dots = "cd ${cfg.dotfiles}";
          todo = "clear && grep -rnw ${cfg.dotfiles} --exclude-dir=__unused_or_deprecated -e '@todo'";
          keycodes = "xev | grep -A2 --line-buffered '^KeyRelease' | sed -n '/keycode /s/^.*keycode \([0-9]*\).* (.*, \(.*\)).*$/\1 \2/p'";

          # Git shortcuts for the lazy ass I am
          # ga    = "git add";
          # gaa   = "git add --all";
          # gaacm = "git add --all && git commit -S -m";
          # gb    = "git branch";
          # gc    = "git commit -S";
          # gch   = "git checkout";
          # gchb  = "git checkout -b";
          # gcl   = "git clone";
          # gcm   = "git commit -S -m";
          # gd    = "git diff";
          # gm    = "git merge";
          # gpl   = "git pull";
          # gplo  = "git pull origin";
          # gps   = "git push";
          # gpso  = "git push origin";
          # gs    = "git status";

          # Tailscale shortcuts
          tsup-dimeritium = ''
            mullvad disconnect && \
            tailscale up --force-reauth --operator=$USER \
              --login-server=https://headscale.sunflower-cloud.com:8080 \
              --auth-key $(cat /run/agenix/auth/tailscale/dimeritium)                                                                 '';
          tsup-np = ''
            mullvad disconnect && \                                                                                                     tailscale up --force-reauth --operator=$USER \
              --login-server=https://headscale.nouveaux-paradigmes.be \
              --auth-key $(cat /run/agenix/auth/tailscale/nouveauxparadigmes)                                                         '';
          tsdown = "tailscale down --accept-risk=all && mullvad connect";
        };
      };

      programs = {
        git = {
          # enable = true;
          settings.user = {
            name = "Karl";
            email = "karl@delandsheere.be"; };
          signing = {
            key = "D4EFAA4CD5AE64F4";
            # signByDefault = true;
            };
        };

        zsh = {
          enable = true;
          initContent = ''
            autoload -U promptinit; promptinit
            zstyle ':prompt:pure:path' color red
            zstyle ':prompt:pure:prompt:*' color red
            zstyle ':prompt:pure:git:stash' show yes
            prompt pure
          '';
        };
      };
    };
  };
}
