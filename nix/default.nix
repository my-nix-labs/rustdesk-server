{ pkgs, src, system }:

let
  version = (builtins.fromTOML (builtins.readFile (src + "/Cargo.toml"))).package.version;

  s6Arch = {
    "x86_64-linux" = "x86_64";
    "aarch64-linux" = "aarch64";
  }.${system} or (throw "Unsupported system for rustdesk-server docker image: ${system}");

  server = pkgs.callPackage ./server.nix { inherit src version; };

  s6Overlay = pkgs.callPackage ./s6-overlay.nix { inherit s6Arch; };

  rootfs = pkgs.callPackage ./rootfs.nix { inherit src server; };

  dockerImage = pkgs.callPackage ./docker.nix { inherit s6Overlay rootfs version; };
in
{
  inherit server s6Overlay rootfs;

  dockerImage = dockerImage;

  default = dockerImage;
}
