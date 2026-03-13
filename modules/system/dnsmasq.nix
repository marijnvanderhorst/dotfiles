{ pkgs, ... }:

{
  services.dnsmasq = {
    enable = true;
    package = pkgs.dnsmasq;

    addresses = {
      # Route all .test domains to localhost (IPv4)
      # address=/.test/127.0.0.1
      "test" = "127.0.0.1";

      # Route all .test domains to localhost (IPv6)
      # address=/.test/::1
      # "test" = "::1";
    };

    servers = [
      "9.9.9.9"
      "149.112.112.112"
    ];
  };
}
