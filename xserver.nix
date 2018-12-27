{ ... }:
{
  services.xserver = {
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
        ];
      };
    };

    desktopManager = {
      default = "none";
      xfce.enable = true;
    };

    displayManager.sddm = {
      enable = true;
      autoLogin = {
        enable = true;
        user = "bhipple";
      };
    };
  };
}
