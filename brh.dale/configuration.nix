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
  # FIXME
  #environment.etc = {
  #  "resolv.conf".text = "nameserver 192.168.1.169\n";
  #};

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
    enable = true;
    package = pkgs.ollama-cuda;
    # Keep in sync with contextWindow in ~/dotfiles/pi/agent/models.json
    environmentVariables = {
      OLLAMA_CONTEXT_LENGTH = "65536";
      # Flash attention + 8-bit KV cache roughly halve context memory,
      # so 64K still fits on the 4090 alongside a 27B Q4 model.
      OLLAMA_FLASH_ATTENTION = "1";
      OLLAMA_KV_CACHE_TYPE = "q8_0";
    };
    loadModels = [
      "qwen3.6:27b"
      "qwen3.6:35b-a3b"
    ];
  };

  services.influxdb.enable = true;

  system.stateVersion = "25.11";

  # See options with `man mount`
  fileSystems."/".options = [
    "noatime" # Large performance boost
  ];
}
