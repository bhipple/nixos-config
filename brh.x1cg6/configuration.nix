{ config, pkgs, ... }:
let
  nixos-hardware = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixos-hardware/archive/1e2c130d38d72860660474c36207b099c519cb6a.tar.gz";
    sha256 = "052kkvc0x8rizsbnjdaybiw18ihrr7gx6yyvw5g7x16fpvrsh1vz";
  };

in {
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

  boot.initrd.luks.devices = [{
    name = "root";
    device = "/dev/nvme0n1p2";
    preLVM = true;
    allowDiscards = true;
  }];

  networking.hostName = "brh.x1cg6";

  services.influxdb.enable = true;
  services.grafana = {
    enable = true;
    # This isn't available until NixOS 19.03
    # provision = {
    #   datasources = [{
    #     name = "influx-finance";
    #     type = "influxdb";
    #     access = "direct";
    #     url = "http://localhost:8086";
    #     database = "finance";
    #     isDefault = true;
    #   }];
    # };
  };
}
