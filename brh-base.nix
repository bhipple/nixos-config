# Base defaults for my personal machines
{ config, pkgs, ... }:
{
  services.xserver.windowManager.default = "xmonad";
  services.xserver.desktopManager.default = "none";

  virtualisation = {
    # Enable Docker Daemon
    docker.enable = true;

    # Enable virtualbox
    virtualbox.host.enable = true;
    virtualbox.guest.enable = true;
  };

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
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="plugdev", ATTRS{idVendor}=="2c97"
  '';

  security.sudo.extraConfig = ''
    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/nix-channel --update
    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/poweroff
    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/reboot
    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/systemctl restart openvpn-pia.service
    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/systemctl start openvpn-pia.service
    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/systemctl stop openvpn-pia.service
  '';
}
