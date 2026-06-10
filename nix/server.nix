{ lib, pkgs, rustPlatform, src, version }:

rustPlatform.buildRustPackage {
  pname = "rustdesk-server";
  inherit version src;

  cargoLock = {
    lockFile = src + "/Cargo.lock";
    outputHashes = {
      "async-speed-limit-0.3.1" = "sha256-iOel6XA07RPrBjQAFLnxXX4VBpDrYZaqQc9clnsOorI=";
      "confy-0.4.0-2" = "sha256-V7BCKISrkJIxWC3WT5+B5Vav86YTQvdO9TO6A++47FU=";
      "default_net-0.1.0" = "sha256-wwVcnS99I1NJFeSihy5YrB5p0y+OHXTX81DQ+TtyFBU=";
      "machine-uid-0.3.0" = "sha256-rEOyNThg6p5oqE9URnxSkPtzyW8D4zKzLi9pAnzTElE=";
      "reqwest-0.11.23" = "sha256-kEUT+gs4ziknDiGdPMLnj5pmxC5SBpLopZ8jZ34GDWc=";
      "sysinfo-0.29.10" = "sha256-/UsFAvlWs/F7X1xT+97Fx+pnpCguoPHU3hTynqYMEs4=";
      "tokio-socks-0.5.2-1" = "sha256-i1dfNatqN4dinMcyAdLhj9hJWVsT10OWpCXsxl7pifI=";
    };
  };

  nativeBuildInputs = with pkgs; [
    pkg-config
    protobuf
  ];

  buildInputs = with pkgs; [
    openssl
    libsodium
    sqlite
  ];

  doCheck = false;

  meta = with lib; {
    description = "RustDesk ID/Rendezvous and Relay servers (hbbs, hbbr)";
    license = licenses.agpl3Only;
    mainProgram = "hbbs";
  };
}
