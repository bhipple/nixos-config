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

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sdc";

  networking.hostName = "brh.desktop";
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

  # Set your time zone.
  time.timeZone = "America/New_York";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
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

  # List services that you want to enable:
  services = {
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

      # Proprietary AMD Drivers
      #videoDrivers = [ "ati_unfree" ];

      # Override the caps-lock key with the compose key
      # See /etc/X11/xkb/rules/evdev.lst for more options
      xkbOptions = "caps:ctrl_modifier";

      # Enable XMonad Configuration extras
      windowManager.default = "xmonad";
      windowManager.xmonad.enable = true;
      windowManager.xmonad.enableContribAndExtras = true;
      windowManager.xmonad.extraPackages = haskellPackages: [
        haskellPackages.xmobar
        haskellPackages.xmonad-contrib
        haskellPackages.xmonad-extras
      ];

      # Enable the KDE Desktop Environment.
      displayManager.kdm.enable = true;
      desktopManager.kde4.enable = true;
    };

    openssh = {
      enable = true;
      permitRootLogin = "no";
      passwordAuthentication = false;
    };
  };

  programs.zsh.enable = true;
  users.defaultUserShell = "/run/current-system/sw/bin/zsh";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.bhipple = {
    isNormalUser = true;
    home = "/home/bhipple";
    description = "Benjamin Hipple";
    extraGroups = [ "wheel" "networkmanager" ];
    shell = "/run/current-system/sw/bin/zsh";
    uid = 1000;
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.09";

  # Copy this configuration file to
  # /var/run/current-system/configuration.nix
  system.copySystemConfiguration = true;
}
