# Impermanence setup
# The idea is to wipe /root at every boot to keep things clean
# except for directories and files declared persistents
# Needs the impermanence flake
# @todo see if we can import the flake right here instead of in the main flake
#
# Based on so many sources but the latest is
# https://github.com/kjhoerr/dotfiles/blob/trunk/.config/nixos/os/persist.nix
# ---------------------------------------------------------------------------
{ config, impermanence, lib, pkgs, ... }: let
  differences = pkgs.writeShellApplication {
    name = "differences";
    runtimeInputs = [ pkgs.btrfs-progs ];
    text = builtins.readFile ../scripts/differences.sh;
  };
in
{
  imports = [
    impermanence.nixosModules.impermanence
  ];

  config = {
    # Rollback routine on every boot
    # ------------------------------
    boot.initrd.systemd.services.rollback = {
      description = "Rollback BTRFS root and home subvolumes to a pristine state";
      wantedBy = [ "initrd.target" ];
      requires = [ "dev-nvme0n1p2.device" ];
      after = [ "dev-nvme0n1p2.device" ];
      before = [ "sysroot.mount" ];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
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
          "/etc/nixos"
          "/etc/NetworkManager/system-connections"

          # /var/lib/...
          "/var/lib/nixos"
          "/var/lib/bluetooth"
          "/var/lib/upower"
        ];

        files = [
          # /etc/...
          "/etc/machine-id"

          # /var/lib/...
          "/var/lib/NetworkManager/secret_key"
          "/var/lib/NetworkManager/seen-bssids"
          "/var/lib/NetworkManager/timestamps"

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
