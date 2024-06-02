{ ... }:
{
  services.xserver = {
    enable = true;

    xkb = {
      layout = "us";

      # Override the caps-lock key with the compose key
      # See /etc/X11/xkb/rules/evdev.lst for more options
      options = "caps:ctrl_modifier";
    };

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

  };

  services.displayManager = {
    defaultSession = "none+i3";
    autoLogin = {
      enable = true;
      user = "bhipple";
    };
  };
}
