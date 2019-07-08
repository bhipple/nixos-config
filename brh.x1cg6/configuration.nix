{ config, pkgs, ... }:
let
  nixos-hardware = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixos-hardware/archive/54268d11ae4e7a35e6085c5561a8d585379e5c73.tar.gz";
    sha256 = "1nvhbawa9y2vn68zgqnyyxiv8ijrqxgxzz1bij2lcac40lf1f8nl";
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
    provision = {
      enable = true;
      datasources = [{
        name = "personal";
        type = "influxdb";
        access = "direct";
        url = http://localhost:8086;
        database = "personal";
        isDefault = true;
      } {
        name = "brh-food";
        type = "influxdb";
        access = "direct";
        url = http://localhost:8086;
        database = "brh-food";
      }
      ];
      dashboards = [{
        options.path = ../grafana/provisioning/dashboards;
      }];
    };
  };
}
