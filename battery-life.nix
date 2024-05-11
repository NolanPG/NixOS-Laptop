{config, lib, pkgs, ...}:

{
  powerManagement = {
    enable = true;
    powertop.enable = true;
    cpuFreqGovernor = "powersave";
  };

  services = {
    thermald.enable = true;

    system76-scheduler = {
      enable = true;
      useStockConfig = true;
    };

    power-profiles-daemon.enable = true;
    auto-cpufreq = {
      enable = true;
      settings = {

        battery = {
          governor = "powersave";
          turbo = "never";
        };

        charger = {
          governor = "performance";
          turbo = "auto";
        };
      };
    };
  };

  environment.systemPackages = [ pkgs.kdePackages.drkonqi ];
}