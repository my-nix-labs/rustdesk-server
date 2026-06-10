{ pkgs, src, server }:

pkgs.runCommand "rustdesk-server-rootfs" { } ''
  mkdir -p $out/usr/bin $out/etc
  cp -r ${src}/docker/rootfs/etc $out/
  cp ${src}/docker/rootfs/usr/bin/healthcheck.sh $out/usr/bin/
  chmod +x $out/usr/bin/healthcheck.sh
  ln -s ${server}/bin/hbbs $out/usr/bin/hbbs
  ln -s ${server}/bin/hbbr $out/usr/bin/hbbr
  ln -s ${server}/bin/rustdesk-utils $out/usr/bin/rustdesk-utils
''
