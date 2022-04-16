{ pkgs, ... }:

{
  services.cron.enable = true;
  services.cron.systemCronJobs = [
    "*/15 *  * * *   bhipple  systemd-cat -t 'brh-cron'  /home/bhipple/bin/sync-repos"
    "0    *  * * *   bhipple  systemd-cat -t 'brh-cron'  cd /home/bhipple/src/nixpkgs && git pull"
    "0    20 * * 0   bhipple  systemd-cat -t 'brh-cron'  /home/bhipple/ledger/scripts/update-prices.sh"
  ];
}
