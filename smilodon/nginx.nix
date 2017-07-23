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

          # "~ \.php$" = {
          #   index = "index.php";
          #   extraConfig = ''
          #     include ${pkgs.nginx}/conf/fastcgi_params;
          #     fastcgi_pass unix:/run/phpfpm/smilodonpool.sock;
          #   '';
          # };
        };

        # TODO
        enableSSL = false;
        forceSSL = false;
      };

    };
  };

  # services.phpfpm = {
  #   poolConfigs = {
  #     smilodonpool = ''
  #       user = phpfpm
  #       group = phpfpm
  #       listen = /run/phpfpm/smilodonpool.sock
  #       listen.owner = nginx
  #       listen.group = nginx
  #       pm = dynamic
  #       pm.max_children = 75
  #       pm.start_servers = 10
  #       pm.min_spare_servers = 5
  #       pm.max_spare_servers = 20
  #       pm.max_requests = 500
  #     '';
  #   };
  # };

  # users.extraUsers.phpfpm = {
  #   description = "PHP FastCGI user";
  #   uid = 2222;
  #   group = "phpfpm";
  # };

  # users.extraGroups.phpfpm.gid = 2222;
}
