{ config, pkgs, ... }:
let
  nixos-hardware = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixos-hardware/archive/adecd1113c2d4137ef23237f9af450736fd8d2cc.tar.gz";
    sha256 = "1k4zl5c0ak525japzxmddimzac1szhlwd83b7i4v24a32lbwhlkz";
  };

  nixpkgs-unstable = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/a36056d068770432a5203ba86e1a3accdc71aa76.tar.gz";
    sha256 = "0j24chzb6xm1hpizd0yw24iiwnab2sy80dsxz26am6xhc0nrm9j1";
  };

  unstable-pkgs = import nixpkgs-unstable {};

in
{
  imports = [
    ./hardware-configuration.nix
    "${nixos-hardware}/lenovo/thinkpad/x1/6th-gen"

    ../base.nix
    ../brh-base.nix
    ../hosts.nix
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

  networking.hostName = "brh.x1cg6";

  services = {
    fwupd = {
      enable = true;
      #package = unstable-pkgs.fwupd;
    };

    jenkins = {
      enable = false;
    };

    upower.enable = true;
  };
}
