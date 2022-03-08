{ pkgs, ... }:

{
  services.cron.enable = true;
  services.cron.systemCronJobs = [
    "*/15 * * * *   bhipple  systemd-cat -t 'brh-cron'  /home/bhipple/bin/sync-repos"
    "0 22 * * 0     bhipple  systemd-cat -t 'brh-cron'  /home/bhipple/ledger/scripts/update-prices.sh"
  ];
}
