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

  # Ledger Nano S udev rule for Chromium plugin write access
  services.udev.extraRules = ''
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0001", MODE="0660", TAG+="uaccess", TAG+="udev-acl"
  '';
}
