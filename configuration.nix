# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # VPN
      ./pia.nix
    ];

  boot.kernelParams = [ "intel_pstate=no_hwp" ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices = [{
    name = "root";
    device = "/dev/sda2";
    preLVM = true;
    allowDiscards = true;
  }];

  networking.hostName = "brh.laptop";
  networking.networkmanager.enable = true;

  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Enable Docker Daemon
  virtualisation.docker.enable = true;

  time.timeZone = "America/New_York";

  # System profile packages
  environment.systemPackages = with pkgs; [
    wget
    xlibs.xmessage
    amdappsdkFull
    dmenu
    gitAndTools.hub

    (haskellPackages.ghcWithPackages (ps: with ps;
      [ xmonad
        xmobar
        xmonad-contrib
        xmonad-extras ]))
  ];

  services = {
    cron = {
      enable = true;
      systemCronJobs = [
        "0 * * * *  bhipple  /home/bhipple/bin/sync-repos > /tmp/bhipple-sync-repos"
      ];
    };

    postfix = {
      enable = true;
    };

    xserver = {
      enable = true;
      layout = "us";

      # Override the caps-lock key with the compose key
      # See /etc/X11/xkb/rules/evdev.lst for more options
      xkbOptions = "caps:ctrl_modifier";

      # Enable XMonad Configuration extras
      windowManager = {
        default = "xmonad";
        xmonad = {
          enable = true;
          enableContribAndExtras = true;
          extraPackages = haskellPackages: [
            haskellPackages.xmobar
            haskellPackages.xmonad-contrib
            haskellPackages.xmonad-extras
          ];
        };
      };

      desktopManager = {
        plasma5.enable = false;
        xterm.enable = true;
        xfce.enable = true;

        # Just use xmonad
        default = "none";
      };
    };

    openssh = {
      enable = true;
      permitRootLogin = "no";
      passwordAuthentication = false;
    };
  };

  programs = {
    zsh.enable = true;
    #slock.enable = true;
  };

  users.defaultUserShell = "/run/current-system/sw/bin/zsh";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.bhipple = {
    isNormalUser = true;
    home = "/home/bhipple";
    description = "Benjamin Hipple";
    extraGroups = [ "docker" "networkmanager" "wheel" ];
    shell = "/run/current-system/sw/bin/zsh";
    uid = 1000;
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";

  # Copy this configuration file to
  # /var/run/current-system/configuration.nix
  system.copySystemConfiguration = true;
}
