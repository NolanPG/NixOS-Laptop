{ config, libs, pkgs, ... }:

{
  # Enabling Wi-Fi
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    interfaces.wlan0.useDHCP = true;
    # networkmanager.dhcp = "dhcpcd";
    wireless.dbusControlled = true;
    wireless.allowAuxiliaryImperativeNetworks = true;
    # useDHCP = false;

    firewall = {
      allowedTCPPorts = [ 80 443 8080 8081 8000 8001 3000 6600 7201 ];
      allowedUDPPorts = [ 80 443 8080 8081 8000 8001 3000 6600 7201 51820 ];
      allowedTCPPortRanges = [{ from = 1714; to = 1764; }];
      allowedUDPPortRanges = [{ from = 1714; to = 1764; }];
    };

    hosts = { "127.0.0.1" = [ "work" "www" "spa-test" ]; };

    # # Set up Wireguard as a proxy
    # wireguard = { 
    #   enable = true;

    #   interfaces = {
        
    #     wg0 = {
    #       ips = [
    #         "192.168.1.133/24"
    #         "192.168.6.215/32"
    #       ];
    #       listenPort = 51280;
    #       privateKey = "GCzx5re4yvoPmwtNCfchZ/tSDp0cwcqJTjVsDtIvglM=";

    #       peers = [
    #         {
    #           publicKey = "bRlmdNfjTVQSHDON4OQEg9dHaKW2bLXVHOxc88Fd+kM=";
    #           allowedIPs = [
    #             "0.0.0.0/0, ::/0"
    #           ];
    #           endpoint = "pt1.vpnjantit.com:1024";
              
    #           # Send keepalives every 25 seconds. Important to keep NAT tables alive.
    #           persistentKeepalive = 25;
    #         }
    #       ];
    #     };
    #   };
    # };
  };

  services.create_ap = {
    enable = true;
    settings = {
      INTERNET_IFACE = "enp8s0";
      WIFI_IFACE = "wlan0";
      SSID = "nolan-nixos";
      PASSPHRASE = "awsqd1e23";
    };
  };

  services.openssh = {
    enable = true;

    settings.PasswordAuthentication = true;
  };
}