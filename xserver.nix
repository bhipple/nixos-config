{ ... }:
{
  services.xserver = {
    enable = true;
    layout = "us";

    # Override the caps-lock key with the compose key
    # See /etc/X11/xkb/rules/evdev.lst for more options
    xkbOptions = "caps:ctrl_modifier";

    windowManager = {
      i3.enable = true;
    };

    desktopManager = {
      xfce = {
        enable = false;
        noDesktop = false;
        enableXfwm = false;
      };
    };

    displayManager = {
      defaultSession = "none+i3";
      autoLogin = {
        enable = true;
        user = "bhipple";
      };
    };
  };
}
