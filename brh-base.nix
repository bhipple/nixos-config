# Base defaults for my personal machines
{ config, pkgs, ... }:
{
  environment.variables = { IPFS_PATH = "/var/lib/ipfs"; };

  # System profile packages
  environment.systemPackages = with pkgs; [
    dmenu
    gitAndTools.gitFull
    wget
    xlibs.xmessage

    (haskellPackages.ghcWithPackages (ps: with ps;
      [ xmonad
        xmobar
        xmonad-contrib
        xmonad-extras ]))
  ];

  hardware = {
    opengl.enable = true;
    opengl.driSupport = true;
    opengl.driSupport32Bit = true;
    pulseaudio = {
      enable = true;
      support32Bit = true;
      systemWide = false;
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 4001 8080 ];
    allowedUDPPorts = [ 34197 ];
  };

  networking.networkmanager.enable = true;

  programs.adb.enable = true;

  users.extraGroups = {
    plugdev = { gid = 500; };
  };

  services = {
    cron = {
      systemCronJobs = [
        "* * * * *  bhipple  /home/bhipple/bin/sync-repos > /tmp/bhipple-sync-repos 2&>1"
      ];
    };

    postfix.enable = true;
    ipfs.enable = true;

    xserver = {
      windowManager.default = "xmonad";
      desktopManager.default = "none";
      displayManager.sddm.autoLogin = {
        enable = true;
        user = "bhipple";
      };
    };

    # Ledger Nano S udev rule for Chromium plugin write access
    udev.extraRules = ''
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0001", MODE="0660", TAG+="uaccess", TAG+="udev-acl"
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="plugdev", ATTRS{idVendor}=="2c97"
    '';

  };

  security.sudo.extraConfig = ''
    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/nix-channel --update
    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/poweroff
    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/reboot
    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/systemctl restart openvpn-pia.service
    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/systemctl start openvpn-pia.service
    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/systemctl stop openvpn-pia.service
  '';

  virtualisation = {
    docker.enable = true;

    virtualbox.host.enable = false;
    virtualbox.guest.enable = false;
  };
}
