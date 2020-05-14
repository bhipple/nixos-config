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

    (
      haskellPackages.ghcWithPackages (
        ps: with ps;
        [
          xmonad
          xmobar
          xmonad-contrib
          xmonad-extras
        ]
      )
    )
  ];

  hardware = {
    opengl.enable = true;
    opengl.driSupport = true;
    opengl.driSupport32Bit = true;
    pulseaudio = {
      enable = true;
      # Use the full package to enable Bluetooth audio support
      package = pkgs.pulseaudioFull;
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

  nix = {
    autoOptimiseStore = true;

    # Only set to true when I'm actually using the AWS build farm; otherwise, it
    # waits for a connection timeout on every build before proceeding.
    inherit (import ./distribute.nix) distributedBuilds;

    buildMachines = [
      {
        hostName = "borg.brhnbr.com";
        system = "x86_64-linux";
        maxJobs = 16;
        speedFactor = 2;
        supportedFeatures = [ "big-parallel" ];
      }
    ];

    # When using a remote builder, prefer its binary cache rather than the
    # submitter's uploading.
    extraOptions = ''
      builders-use-substitutes = true
    '';

    # Use my cachix cache
    binaryCaches = [
      "https://cache.nixos.org/"
      "https://brh.cachix.org/"
    ];

    binaryCachePublicKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "brh.cachix.org-1:EwfpYMNqGUy4alrgyBrOVhh0kGR92ZFNK8jayAJmKXA="
    ];

    trustedUsers = [ "bhipple" ];
  };

  programs.adb.enable = false;
  programs.gnupg.agent.enable = true;

  services = {
    cron = {
      systemCronJobs = [
        "*/15 * * * *   bhipple  systemd-cat -t 'brh-cron'  /home/bhipple/bin/sync-repos"
        "0 * * * *      bhipple  systemd-cat -t 'brh-cron'  /home/bhipple/ledger/scripts/influx-personal.sh"
        "0 22 * * 0     bhipple  systemd-cat -t 'brh-cron'  /home/bhipple/ledger/scripts/update-prices.sh"
        "30 22 * * 0    bhipple  systemd-cat -t 'brh-cron'  /home/bhipple/ledger/scripts/myfitnesspal-data.py"
      ];
    };

    grafana = {
      enable = true;
      provision = {
        enable = true;
        datasources = [
          {
            name = "personal";
            type = "influxdb";
            access = "direct";
            url = http://localhost:8086;
            database = "personal";
            isDefault = true;
          }
          {
            name = "brh-finance";
            type = "influxdb";
            access = "direct";
            url = http://localhost:8086;
            database = "brh-finance";
          }
          {
            name = "brh-food";
            type = "influxdb";
            access = "direct";
            url = http://localhost:8086;
            database = "brh-food";
          }
        ];
        dashboards = [
          {
            options.path = ./grafana/provisioning/dashboards;
          }
        ];
      };
    };

    influxdb.enable = true;

    ipfs.enable = false;

    nginx = {
      enable = true;
      config = ''
        events { }
        http {
          server {
            listen 80;
            root /home/bhipple/public_html;
            location / {
              index index.html;
              autoindex on;
            }
          }
        }
      '';
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
    ''
    # Ergodox Ez Rules
    + ''
      ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", ENV{ID_MM_DEVICE_IGNORE}="1"
      ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789A]?", ENV{MTP_NO_PROBE}="1"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789ABCD]?", MODE:="0666"
      KERNEL=="ttyACM*", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", MODE:="0666"

      # STM32 rules for the Planck EZ Standard / Glow
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", \
          MODE:="0666", \
          SYMLINK+="stm32_dfu"

      # Oryx training rule for the Ergodox EZ Original / Shine / Glow
      SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="1307", GROUP="plugdev"
      # Rule for the Planck EZ Standard / Glow
      SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="6060", GROUP="plugdev"
    '';
  };

  security.sudo.extraConfig = ''
    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/nix-channel --update

    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/bluetoothctl
    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/poweroff
    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/reboot

    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/systemctl restart display-manager

    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/systemctl restart openvpn-protonvpn
    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/systemctl start openvpn-protonvpn
    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/systemctl status openvpn-protonvpn
    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/systemctl stop openvpn-protonvpn


    bhipple ALL = (root) NOPASSWD: /run/current-system/sw/bin/slock
  '';

  users.extraGroups = {
    plugdev = { gid = 500; };
  };

}
