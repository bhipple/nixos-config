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
    "${nixos-hardware}/lenovo/thinkpad/x1/6th-gen"

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

  boot.initrd.luks.devices.root = {
    name = "root";
    device = "/dev/nvme0n1p2";
    preLVM = true;
    allowDiscards = true;
  };

  hardware.bluetooth.enable = true;

  # See options with `man mount`
  fileSystems."/".options = [
    "noatime" # Large performance boost
    "discard" # Send TRIM commands to the ssd
  ];

  networking.hostName = "brh-x1cg6";

  services.upower.enable = true;
  services.hardware.bolt.enable = true;
}
