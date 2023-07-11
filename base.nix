# Minimal base environment for all my Nix servers
{ pkgs, ... }:
{
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  networking = {
    nameservers = [ "9.9.9.9" ];
  };

  nix.settings = {
    experimental-features = "nix-command flakes";
  };

  nixpkgs.config.allowUnfree = true;

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
  system.stateVersion = "21.05";
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
