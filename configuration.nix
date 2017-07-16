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
      #./private-internet-access.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sdd";
  boot.loader.grub.efiSupport = false;

  networking.hostName = "smilodon";
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

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
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

  environment.variables = { IPFS_PATH = "/var/lib/ipfs/.ipfs"; };

  # List services that you want to enable:
  services = {
    xserver = {
      enable = true;
      layout = "us";

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

      desktopManager = {
        plasma5.enable = false;
        xterm.enable = true;
        xfce.enable = true;
        default = "xfce";
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

  users.extraUsers.smilodon = {
    isNormalUser = true;
    description = "Smilodon";
    extraGroups = [ "adbusers" "smilodon" "docker" "ipfs" "networkmanager" "wheel" ];
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";

  # Copy this configuration file to
  # /var/run/current-system/configuration.nix
  system.copySystemConfiguration = true;
}
