{ config, pkgs, ... }:
let
  nixos-hardware = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixos-hardware/archive/3f6f874dfc34d386d10e434c48ad966c4832243e.tar.gz";
    sha256 = "12l4543jq6phan1575hcghnxrkg1varmqjc3i4zmgsgd3cf4wndr";
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
    ../vpn/vpn.nix
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

  system.stateVersion = "25.05";

}
