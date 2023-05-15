{
  description = "My firt gui app";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-root.url = "github:srid/flake-root";
    mission-control.url = "github:Platonic-Systems/mission-control";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs = inputs@{ flake-parts, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = nixpkgs.lib.systems.flakeExposed;
      imports = [
        inputs.flake-root.flakeModule
        inputs.mission-control.flakeModule
        inputs.treefmt-nix.flakeModule
      ];
      perSystem = { config, pkgs, ... }: {
        treefmt.config = {
          inherit (config.flake-root) projectRootFile;
          package = pkgs.treefmt;
          programs.nixpkgs-fmt.enable = true;
          programs.rustfmt = {
            enable = true;
            edition = "2021";
          };
          programs.beautysh = {
            enable = true;
            indent_size = 4;
          };
        };
        mission-control.scripts = {
          fmt = {
            description = "Format the source tree";
            exec = config.treefmt.build.wrapper;
            category = "Tools";
          };
          run = {
            description = "Run my app";
            exec = "cargo run";
          };
        };
        packages.default = pkgs.callPackage ./build.nix { };
        devShells.default = pkgs.mkShell {
          inputsFrom = [
            config.packages.default
            config.flake-root.devShell
            config.mission-control.devShell
          ];
          buildInputs = with pkgs; [
            gtk4
            pkg-config
          ];
        };
      };
    };
}
