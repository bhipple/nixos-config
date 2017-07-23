{ config, pkgs, ... }:

{
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedTlsSettings = true;

    virtualHosts = {
      "smilodons.org" = {
        default = true;
        serverAliases = [ "www.smilodons.org" "localhost" ];

        locations = {
          "/" = {
            root = "/data/www";
            index = "index.html";
            extraConfig = "autoindex on;";
          };
        };

        # TODO
        enableSSL = false;
        forceSSL = false;
      };

    };
  };
}
