# Base defaults for my personal machines
{ pkgs, ... }:
{
  # System profile packages
  environment.systemPackages = with pkgs; [
    dmenu
    gitAndTools.gitFull
    ipfs
    slock
    tmux
    wget
    xautolock
    xlibs.xmessage
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
      # Doesn't work!
      # extraConfig = ''
      #   load-module module-detect
      # '';
    };
  };

  location = {
    latitude = 40.71427;
    longitude = -74.00597;
  };

  networking.firewall = let
    ssh = [ 22 ];
    wireguard = [ 51820 ];
  in {
    enable = true;
    allowedTCPPorts = ssh;
    allowedUDPPorts = wireguard;
  };

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
    fwupd.enable = true;

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

              sendfile on;
              tcp_nopush on;
              tcp_nodelay on;
              keepalive_timeout 65;
            }
          }
        }
      '';
    };

    redshift = {
      enable = false;
      temperature.day = 3500;
      temperature.night = 3500;
      brightness.day = "1.0";
      brightness.night = "1.0";
    };

    syncthing = {
      enable = true;
      user = "bhipple";
      group = "users";
      dataDir = "/home/bhipple/syncthing";
      openDefaultPorts = true;
    };
  };

  users.extraGroups = {
    plugdev = { gid = 500; };
  };

}
