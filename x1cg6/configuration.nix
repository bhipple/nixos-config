{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../base.nix
    ../brh-base.nix
    # ../hosts.nix
    # ../xserver.nix

    # VPN
    # ../vpn.nix
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

  services.xserver = {
    enable = true;

    desktopManager.xfce.enable = true;

    windowManager = {
      xmonad = {
        enable = true;
        enableContribAndExtras = true;
        extraPackages = haskellPackages: [
          haskellPackages.xmobar
        ];
      };
    };

    displayManager.sddm = {
      enable = true;
      autoLogin = {
        enable = false;
        user = "bhipple";
      };
    };
  };
}
