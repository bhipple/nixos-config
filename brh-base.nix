# Base defaults for my personal machines
{ config, pkgs, ... }:
{
  services.xserver.windowManager.default = "xmonad";
  services.xserver.desktopManager.default = "none";

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 4001 8080 ];
    allowedUDPPorts = [ 34197 ];
  };

  services.xserver.displayManager.sddm.autoLogin = {
      enable = true;
      user = "bhipple";
  };
}
