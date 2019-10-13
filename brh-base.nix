# Base defaults for my personal machines
{ pkgs, ... }:
{
  # System profile packages
  environment.systemPackages = with pkgs; [
    dmenu
    gitAndTools.gitFull
    ipfs
    slock
    wget
    xautolock
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

  location = {
    latitude = 40.71427;
    longitude = -74.00597;
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 4001 8080 ];
    allowedUDPPorts = [ 8080 34197 ];
  };

  networking.networkmanager.enable = true;
  networking.wireless.enable = false;

  programs.adb.enable = false;

  users.extraGroups = {
    plugdev = { gid = 500; };
  };

  services = {
    cron = {
      systemCronJobs = [
        "*/15 * * * *   bhipple  systemd-cat -t 'cron-git-sync' /home/bhipple/bin/sync-repos"
        "0 * * * *      bhipple  systemd-cat -t 'cron-influx'   /home/bhipple/ledger/scripts/influx-personal.sh"
        "0 22 * * 0     bhipple  systemd-cat -t 'cron-pricedb'  /home/bhipple/ledger/scripts/update-prices.sh"
        "30 22 * * 0    bhipple  systemd-cat -t 'cron-food'     /home/bhipple/ledger/scripts/myfitnesspal-data.py"
      ];
    };

    # TODO: Find the cleanest way to get the spacemacs config into the NixPkgs
    # import. It doesn't have my overlay in scope at the moment.
    # emacs = {
    #   enable = false;
    #   package = pkgs.spacemacs;
    # };

    influxdb.enable = true;

    ipfs.enable = false;

    grafana = {
      enable = true;
      provision = {
        enable = true;
        datasources = [{
          name = "personal";
          type = "influxdb";
          access = "direct";
          url = http://localhost:8086;
          database = "personal";
          isDefault = true;
        } {
          name = "brh-finance";
          type = "influxdb";
          access = "direct";
          url = http://localhost:8086;
          database = "brh-finance";
        } {
          name = "brh-food";
          type = "influxdb";
          access = "direct";
          url = http://localhost:8086;
          database = "brh-food";
        }
        ];
        dashboards = [{
          options.path = ./grafana/provisioning/dashboards;
        }];
      };
    };

    redshift.enable = true;

    syncthing = {
      enable = true;
      user = "bhipple";
      group = "users";
      dataDir = "/home/bhipple/syncthing";
      openDefaultPorts = true;
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

    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/systemctl restart openvpn-protonvpn
    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/systemctl start openvpn-protonvpn
    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/systemctl status openvpn-protonvpn
    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/systemctl stop openvpn-protonvpn

    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/slock
  '';
}
