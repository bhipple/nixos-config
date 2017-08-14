# Base defaults for my personal machines
{ config, pkgs, ... }:
{
  services.xserver.windowManager.default = "xmonad";
  services.xserver.desktopManager.default = "none";

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 8080 ];
    allowedUDPPorts = [ 22 34197 ];
  };
}
