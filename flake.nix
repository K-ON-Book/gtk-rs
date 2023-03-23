{
  description = "Description for the project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-darwin" ];
      perSystem = { config, pkgs, ... }: {
        packages.default = pkgs.callPackage ./build.nix { };
        devShells.default = pkgs.mkShell {
          inputsFrom = [ config.packages.default ];
          buildInputs = with pkgs; [
            gtk4
            pkg-config
          ];
        };
      };
    };
}
