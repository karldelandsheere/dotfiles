# Impermanence setup
# The idea is to wipe /root at every boot to keep things clean
# except for directories and files declared persistents
# Needs the impermanence flake
# @todo see if we can import the flake right here instead of in the main flake
#
# Based on so many sources but the latest is
# https://github.com/kjhoerr/dotfiles/blob/trunk/.config/nixos/os/persist.nix
# ---------------------------------------------------------------------------
{ inputs, lib, pkgs, ... }: let
  root-reset-src = builtins.readFile ../scripts/root-reset.sh;

  root-diff = pkgs.writeShellApplication {
    name = "root-diff";
    runtimeInputs = [ pkgs.btrfs-progs ];
    text = builtins.readFile ../scripts/root-diff.sh;
  };
in
{
  # 
  # --------------------
  # imports = [
  #   inputs.impermanence.nixosModules.impermanence
  # ];


  # Declaring the services for impermanence
  # ---------------------------------------
  boot.initrd.systemd = {
    enable = true;

    # Rollback routine on boot
    # ------------------------
    services.rollback = {
      description = "Rollback BTRFS root subvolume to a pristine state";
      wantedBy = [
        "initrd.target"
      ];
      # Only enable this when LUKS will be implemented
      # after = [
      #   # LUKS/TPM process
      #   # "systemd-cryptsetup@enc.service"
      # ];
      before = [
        "sysroot.mount"
      ];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = root-reset-src;
    };

    # Files that are persisted
    # ------------------------
    services.persisted-files = {
      description = "Hard-link persisted files from /persist";
      wantedBy = [
        "initrd.target"
      ];
      after = [
        "sysroot.mount"
      ];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = ''
        mkdir -p /sysroot/etc/
        ln -snfT /persist/etc/machine-id /sysroot/etc/machine-id
      '';
    };
  };


  environment = {
    # Script to find what needs to persist
    # ------------------------------------
    systemPackages = lib.mkBefore [ root-diff ];


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
      ];
    };
  };

  
  # Rollback results in sudo lectures after each reboot
  # ---------------------------------------------------
  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';
}

