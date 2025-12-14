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

  nixpkgs.config.allowUnfree = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia.open = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.latest;
  hardware.nvidia.modesetting.enable = true;

  services.ollama = {
    enable = false;
    acceleration = "cuda";
  };

  #services.grafana = {
  #  enable = true;
  #  settings = {};
  #  provision = {
  #    enable = true;
  #    #datasources = [
  #    #  {
  #    #    name = "brh-finance";
  #    #    type = "influxdb";
  #    #    access = "direct";
  #    #    url = http://localhost:8086;
  #    #    database = "brh-finance";
  #    #  }
  #    #];
  #    dashboards.path = ../grafana/provisioning/dashboards;
  #  };
  #  declarativePlugins = [ pkgs.grafanaPlugins.yesoreyeram-infinity-datasource ];
  #};

  # Replace this with csv; it's too complicated
  services.influxdb.enable = true;

  system.stateVersion = "25.05";

  # See options with `man mount`
  fileSystems."/".options = [
    "noatime" # Large performance boost
  ];
}
