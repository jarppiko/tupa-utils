{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShellNoCC {
    # nativeBuildInputs is usually what you want -- tools you need to run
    nativeBuildInputs = with pkgs.buildPackages; [ shellcheck ];
}
