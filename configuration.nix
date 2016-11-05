# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sdc"; # or "nodev" for efi only

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

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

      # Override the caps-lock key with the compose key
      xkbOptions = "compose:caps";

      # Enable XMonad Configuration extras
      windowManager.xmonad.enable = true;
      windowManager.xmonad.enableContribAndExtras = true;
      windowManager.default = "xmonad"; 
      windowManager.xmonad.extraPackages = haskellPackages: [
        haskellPackages.xmobar
      ];

      #desktopManager.default = "none";
      #desktopManager.xterm.enable = false;
    };
  };

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.kdm.enable = true;
  services.xserver.desktopManager.kde4.enable = true;

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
}
