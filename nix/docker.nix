{ pkgs, s6Overlay, rootfs, version }:

pkgs.dockerTools.buildLayeredImage {
  name = "rustdesk-server-nix-local";
  tag = "nix-${version}";

  contents = [
    pkgs.busybox
    pkgs.bash
    pkgs.coreutils
    pkgs.cacert
    s6Overlay
    rootfs
  ];

  config = {
    # CA bundle for Rust HTTPS; 可选环境变量：KEY_*、ENCRYPTED_ONLY
    Env = [
      "SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt"
    ];
    ExposedPorts = {
      "21115/tcp" = { };
      "21116/tcp" = { };
      "21116/udp" = { };
      "21117/tcp" = { };
      "21118/tcp" = { };
      "21119/tcp" = { };
    };
    Volumes = {
      "/data" = { };
    };
    WorkingDir = "/data";
    Entrypoint = [ "/init" ];
    Healthcheck = {
      Test = [ "CMD" "/usr/bin/healthcheck.sh" ];
      Interval = 10000000000;
      Timeout = 5000000000;
    };
  };

  extraCommands = ''
    mkdir -p data
  '';
}
