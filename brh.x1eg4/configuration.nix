{ config, pkgs, ... }:
let
  nixos-hardware = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixos-hardware/archive/518b9c2159e7d4b7696ee18b8828f9086012923b.tar.gz";
    sha256 = "02ybg89zj8x3i5xd70rysizbzx8d8bijml7l62n32i991244rf4b";
  };
in
{
  imports = [
    ./hardware-configuration.nix
    #"${nixos-hardware}/lenovo/thinkpad/x1-extreme/default.nix"

    ../base.nix
    ../brh-base.nix
    ../cron.nix
    ../email.nix
    ../hosts.nix
    ../sudo.nix
    ../udev.nix
    ../xserver.nix

    # VPN
    ../vpn.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ZFS Settings
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.requestEncryptionCredentials = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s13f0u3u3.useDHCP = true;
  networking.hostId = "173f266b";

  hardware.bluetooth.enable = false;

  # services.xserver.videoDrivers = [ "nvidia" ];

  # See options with `man mount`
  fileSystems."/".options = [
    "noatime" # Large performance boost
  ];

  networking.hostName = "brh-x1eg4";

  services = {
    hardware.bolt.enable = true;
    upower.enable = true;
  };
}
