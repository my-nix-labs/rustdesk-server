{ pkgs, s6Arch, version ? "3.2.0.0" }:

pkgs.runCommand "s6-overlay-${version}-${s6Arch}" { } ''
  mkdir -p $out
  tar -C $out -Jxpf ${pkgs.fetchurl {
    url = "https://github.com/just-containers/s6-overlay/releases/download/v${version}/s6-overlay-noarch.tar.xz";
    hash = "sha256-SwwJB+Z2KBTDGFDg5sZ2LDhVcdRlbrhyWFKwsVhnE7Y=";
  }} --no-same-owner --no-same-permissions
  tar -C $out -Jxpf ${pkgs.fetchurl {
    url = "https://github.com/just-containers/s6-overlay/releases/download/v${version}/s6-overlay-${s6Arch}.tar.xz";
    hash = if s6Arch == "x86_64" then
      "sha256-rZgqgBvXJ1fHsbU1OaFGz3FeZAtNjwpqZxo9G1YP4eI="
    else if s6Arch == "aarch64" then
      "sha256-holz6YIQJXu6cl/1sXqgkgCMmo5RdEmeOLphGo/H5HM="
    else
      throw "Missing s6-overlay hash for ${s6Arch}";
  }} --no-same-owner --no-same-permissions
  mkdir -p $out/var
  ln -sfn $out/run $out/var/run
''
