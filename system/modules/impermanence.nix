# Impermanence setup
# The idea is to wipe /root at every boot to keep things clean
# except for directories and files declared persistents
# Needs the impermanence flake
#
# Based on so many sources but the latest is
# https://github.com/kjhoerr/dotfiles/blob/trunk/.config/nixos/os/persist.nix
# ---------------------------------------------------------------------------
{ config, lib, pkgs, ... }: let
  differences = pkgs.writeShellApplication {
    name = "differences";
    runtimeInputs = [ pkgs.btrfs-progs ];
    text = builtins.readFile ../scripts/differences.sh;
  };

  # isNvme = lib.strings.hasInfix "nvme" config.nouveauxParadigmes.rootDisk;
  # deviceName = ${config.nouveauxParadigmeS.rootDisk} lib.strings.optionalString isNvme "p";

  # @todo Make this more versatile regarding the disk type etc
  requiresAfter = if config.nouveauxParadigmes.encryption.enable
    then "systemd-cryptsetup@cryptroot.service"
    else "dev-nvme0n1p2.device";
in
{
  config = lib.mkIf config.nouveauxParadigmes.impermanence.enable {
    # Rollback routine on every boot
    # ------------------------------
    boot.initrd.systemd.services.rollback = {
      description = "Rollback BTRFS root and home subvolumes to a pristine state";
      wantedBy    = [ "initrd.target" ];
      requires    = [ requiresAfter ];
      after       = [ requiresAfter ];
      before      = [ "sysroot.mount" ];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type             = "oneshot";
      script = builtins.readFile ../scripts/rollback.sh;
    };


    environment = {
      # Script to find what needs to persist
      # ------------------------------------
      systemPackages = lib.mkBefore [
        differences
      ];


      # Now, opt-in what needs to persist
      # ---------------------------------
      persistence."/persist" = {
        hideMounts = true; # What's it doing really?

        directories = [
          # /etc/...
          "/etc/mullvad-vpn"
          "/etc/nixos"
          "/etc/NetworkManager/system-connections"

          # /var/lib/...
          "/var/lib/nixos"
          "/var/lib/bluetooth"
          "/var/lib/upower"

          # /var/cache
          "/var/cache/mullvad-vpn"
        ];

        files = [
          # /etc/...
          "/etc/machine-id"
          "/etc/ssh/ssh_host_ed25519_key"
          "/etc/ssh/ssh_host_ed25519_key.pub"
          "/etc/ssh/ssh_host_rsa_key"
          "/etc/ssh/ssh_host_rsa_key.pub"

          # /var/lib/...
          "/var/lib/NetworkManager/secret_key"
          "/var/lib/NetworkManager/seen-bssids"
          "/var/lib/NetworkManager/timestamps"
          "/var/lib/tailscale/tailscaled.log.conf"
          "/var/lib/tailscale/tailscaled.state"

          # /root/...
          "/root/.local/share/nix/trusted-settings.json"
        ];
      };
    };

  
    # Rollback results in sudo lectures after each reboot
    # ---------------------------------------------------
    security.sudo.extraConfig = ''
      Defaults lecture = never
    '';


    # Allow non-root users
    # --------------------
    programs.fuse.userAllowOther = true;
  };
}
