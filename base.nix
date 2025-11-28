# Minimal base environment for all my Nix servers
{ pkgs, ... }:
{
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # System profile packages
  environment.systemPackages = with pkgs; [
    brave
    chromium
    dmenu
    gitAndTools.gitFull
    gnupg
    pass
    pinentry-curses
    python3
    slock
    tmux
    vim
    wget
    xautolock
    xorg.xmessage
    zellij
    zsh
  ];

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = "nix-command flakes";
      trusted-users = [ "bhipple" ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  programs.browserpass.enable = true;

  programs.gnupg.agent = {
    enable = true;
  };

  programs.ssh = {
    startAgent = true;
    agentTimeout = "10h";
  };

  programs.zsh.enable = true;

  services.cron.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      PasswordAuthentication = false;
    };
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  time.timeZone = "America/New_York";
  users.defaultUserShell = "/run/current-system/sw/bin/zsh";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bhipple = {
    isNormalUser = true;
    description = "Benjamin Hipple";
    extraGroups = [ "adbusers" "bhipple" "docker" "networkmanager" "plugdev" "users" "wheel" ];
    openssh.authorizedKeys.keys = [
      # brh-key
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINCyn5P9LSm/yfox7qrbWthnbAI2yQHoXotI/6iNE1XY"
    ];
  };
}
