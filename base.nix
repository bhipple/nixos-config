# Minimal base environment for all my Nix servers
{ pkgs, ... }:
{
  nix.useSandbox = true;

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  networking = {
    nameservers = [ "1.1.1.1" ];
  };

  programs.ssh = {
    startAgent = true;
    agentTimeout = "10h";
  };

  programs.zsh.enable = true;

  services.cron.enable = true;

  services.openssh = {
      enable = true;
      permitRootLogin = "no";
      passwordAuthentication = true;
      forwardX11 = false;
    };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "18.09";
  time.timeZone = "America/New_York";
  users.defaultUserShell = "/run/current-system/sw/bin/zsh";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.bhipple = {
    isNormalUser = true;
    description = "Benjamin Hipple";
    extraGroups = [ "adbusers" "bhipple" "docker" "ipfs" "networkmanager" "plugdev" "users" "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCuP/Z+l3KI5g0SmZ4s0vv3N2OdUEAwc9sBuFG1d8XYLbJEaaTONBGh2sSzMjqNnetyl1e9lz/Yn/406gksjhweR6A1AqTd/Ty8CKzzOD7YCu0QBMOo+hgHxO3LQS+WbB3ygAjZ/uzakSDwaAxHQcZgRiRNFIf+zadQgJ+4sVB2NDTGL16L1Ok252NpBfGdnojU51E2ZnQLj6Dq5ZgrpLrfZEAJkPqcmcjl2IhoFDveSxTvvmoxBAIbZYgHdQY/hSz7k3UOBIBNNV2u6XxW1pr35ySwJVGFav+6KiZR1IaHAka9GW8EeX0Au9QEmUVIZcdWrJHOB4xO4sgSCKaiI7bB"
    ];
  };
}
