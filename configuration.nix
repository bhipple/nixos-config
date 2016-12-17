# Edit this configuration file to define what should be installed on your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sdc";

  networking.hostName = "brh.desktop";

  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    wget
    xlibs.xmessage
    amdappsdkFull
    #haskellPackages.haskellPlatform.ghc
    #haskellPackages.xmobar
    #haskellPackages.xmonad
    #haskellPackages.xmonadContrib
    #haskellPackages.xmonadExtras
  ];

  # List services that you want to enable:
  services = {
    xserver = {
      enable = true;
      layout = "us";

      # Proprietary AMD Drivers
      videoDrivers = [ "ati_unfree" ];

      # Override the caps-lock key with the compose key
      xkbOptions = "compose:caps";

      # Enable XMonad Configuration extras
      windowManager.xmonad.enable = true;
      windowManager.xmonad.enableContribAndExtras = true;
      windowManager.default = "xmonad";
      windowManager.xmonad.extraPackages = haskellPackages: [
        haskellPackages.xmobar
        #haskellPackages.xmonad
        #haskellPackages.xmpipe
        #haskellPackages.xmonad-windownames
        #haskellPackages.xmonad-contrib
        #haskellPackages.xmonad-extras
        #haskellPackages.xmonad-utils
        #haskellPackages.xmonad-entryhelper
        #haskellPackages.xmonad-eval
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
