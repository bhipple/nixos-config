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
      ./private-internet-access.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sdb";
  boot.loader.grub.efiSupport = false;

  networking.hostName = "brh.desktop";
  networking.networkmanager.enable = true;

  hardware = {
    opengl.enable = true;
    opengl.driSupport = true;
    opengl.driSupport32Bit = true;
    pulseaudio = {
      enable = true;
      support32Bit = true;
      systemWide = false;
      # zeroconf = {
      #   discovery.enable = true;
      #   publish.enable = true;
      # };
    };
  };

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Enable Docker Daemon
  virtualisation.docker.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # System profile packages
  environment.systemPackages = with pkgs; [
    amdappsdkFull
    dmenu
    gitAndTools.hub
    wget
    xlibs.xmessage

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

      # Sets the center monitor to be the primary.
      # Will move the login screen and xmobar onto the center monitor.
      # Waiting on https://github.com/NixOS/nixpkgs/pull/15353 to be merged
      # xrandrHeads = [ "DisplayPort-0"
      #                 { output = "HDMI-0"; primary = true; monitorConfig = ""; }
      #                 "DVI-0"
      #               ];

      # Use proprietary AMD drivers
      videoDrivers = [ "amdgpu-pro" ];

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

    ipfs = {
      enable = true;
    };
  };

  programs = {
    adb.enable = true;
    zsh.enable = true;
  };

  users.defaultUserShell = "/run/current-system/sw/bin/zsh";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.bhipple = {
    isNormalUser = true;
    description = "Benjamin Hipple";
    extraGroups = [ "adbusers" "bhipple" "docker" "ipfs" "networkmanager" "wheel" ];
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";

  # Copy this configuration file to
  # /var/run/current-system/configuration.nix
  system.copySystemConfiguration = true;
}
