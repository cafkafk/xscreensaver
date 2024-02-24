{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, systems, nixpkgs }: let
    eachSystem = f: nixpkgs.lib.genAttrs (import systems) (system: f nixpkgs.legacyPackages.${system});
  in {

    packages = eachSystem (pkgs:
      rec {
        default = xscreensaver;
        xscreensaver = pkgs.xscreensaver.overrideAttrs (old: {
          src = ./.;
        });
      }
    );

    devShells = eachSystem (pkgs:
      let
        inherit pkgs;
      in
        {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [gnumake];
          };
        });
  };
}
