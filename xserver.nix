{ config, pkgs, ... }:
{
    services.xserver = {
      enable = true;
      layout = "us";

      # Override the caps-lock key with the compose key
      # See /etc/X11/xkb/rules/evdev.lst for more options
      xkbOptions = "caps:ctrl_modifier";

      # Enable XMonad Configuration extras
      windowManager = {
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
      };

      displayManager.sddm.enable = true;
    };
}