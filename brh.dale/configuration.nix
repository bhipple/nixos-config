{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix

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

  nixpkgs.config.allowUnfree = true;

  # Camera as webcam support
  programs.gphoto2.enable = true;
  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];

  networking.hostName = "brh-dale";

  # Pi-Hole
  networking.nameservers = [ "192.168.1.169" ];
  environment.etc = {
    "resolv.conf".text = "nameserver 192.168.1.169\n";
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  services.blueman.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General = {
      Enable = "Source,Sink,Media,Socket";
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia.open = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.latest;
  hardware.nvidia.modesetting.enable = true;

  services.ollama = {
    enable = false;
    acceleration = "cuda";
  };

  services.grafana = {
    enable = true;
    settings = {};
    provision = {
      enable = true;
      datasources.settings.datasources = [
        {
          name = "brh-finance";
          type = "influxdb";
          access = "proxy";
          url = "http://localhost:8086";
          jsonData = {
            dbName = "brh-finance";
            httpMode = "GET";
          };
        }
      ];
      dashboards.settings.providers = [
        {
          name = "default";
          options.path = ../grafana/provisioning/dashboards;
        }
      ];
    };
  };

  services.influxdb.enable = true;

  system.stateVersion = "25.11";

  # See options with `man mount`
  fileSystems."/".options = [
    "noatime" # Large performance boost
  ];
}
