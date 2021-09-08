{ config, pkgs, ... }:
let
  nixos-hardware = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixos-hardware/archive/8296b88560d8ac07a885452e094cd454de90ea9b.tar.gz";
    sha256 = "07s1p1qj5knh71lq3nzkxs3mhh5n9dbf6qi87dhkkngp85fjv9il";
  };
in
{
  imports = [
    ./hardware-configuration.nix
    "${nixos-hardware}/lenovo/thinkpad/x1/6th-gen"

    ../base.nix
    ../brh-base.nix
    ../email.nix
    ../hosts.nix
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

  networking.hostName = "brh-x1cg6";

  services = {
    fwupd = {
      enable = true;
    };
    upower.enable = true;
  };
}
