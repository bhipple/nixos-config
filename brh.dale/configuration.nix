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
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };

  nixpkgs.config.allowUnfree = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.latest;
  hardware.nvidia.modesetting.enable = true;

  services.ollama = {
    enable = true;
    acceleration = "cuda";
  };

  # See options with `man mount`
  fileSystems."/".options = [
    "noatime" # Large performance boost
  ];
}
