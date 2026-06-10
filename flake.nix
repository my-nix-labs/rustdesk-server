{
  description = "Reproducible Nix build and Docker image for rustdesk-server";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    # Submodule is its own git repo; use it directly instead of a separate GitHub pin.
    hbb_common = {
      url = "git+file:./libs/hbb_common";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, hbb_common }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        src = pkgs.runCommand "rustdesk-server-src" { } ''
          mkdir -p $out
          cp -r ${self}/. $out/
          chmod -R u+w $out
          rm -rf $out/.git $out/libs/hbb_common
          cp -r ${hbb_common} $out/libs/hbb_common
        '';
        packages = import ./nix/default.nix {
          inherit pkgs src system;
        };
      in
      {
        inherit packages;
        defaultPackage = packages.default;

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            rustc
            cargo
            pkg-config
            openssl
            libsodium
            protobuf
          ];
        };
      });
}
