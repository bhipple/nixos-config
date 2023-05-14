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
    #"${nixos-hardware}/lenovo/thinkpad/x1-extreme/default.nix"

    ../base.nix
    ../brh-base.nix
    ../cron.nix
    #../email.nix
    #../hosts.nix
    ../sudo.nix
    ../udev.nix
    ../xserver.nix

    # VPN
    #../vpn.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s13f0u3u3.useDHCP = true;
  networking.hostId = "173f266b";

  hardware.bluetooth.enable = false;

  # services.xserver.videoDrivers = [ "nvidia" ];

  # See options with `man mount`
  fileSystems."/".options = [
    "noatime" # Large performance boost
  ];

  networking.hostName = "brh-dale";

  services = {
    upower.enable = true;
  };

  # Enable sound with pipewire.
  # sound.enable = true;
  # hardware.pulseaudio.enable = false;
  # security.rtkit.enable = true;
  # services.pipewire = {
  #   enable = true;
  #   alsa.enable = true;
  #   alsa.support32Bit = true;
  #   pulse.enable = true;
  #   # If you want to use JACK applications, uncomment this
  #   #jack.enable = true;

  #   # use the example session manager (no others are packaged yet so this is enabled by default,
  #   # no need to redefine it in your config for now)
  #   #media-session.enable = true;
  # };
}
