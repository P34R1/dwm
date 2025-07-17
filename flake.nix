{
  description = "A Nix-flake-based C/C++ development environment";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      utils,
    }:
    utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        env = pkgs.clangStdenv;

        buildInputs = with pkgs.xorg; [
          libX11
          libXft
          libXinerama
        ];

        src = ./.;
        name = "dwm";
        version = "6.5";
      in
      {
        packages.default = env.mkDerivation {
          inherit
            name
            version
            src
            buildInputs
            ;

          prePatch = ''
            sed -i "s@/usr/local@$out@" config.mk
          '';

          makeFlags = [ "CC=${env.cc.targetPrefix}cc" ];
        };

        devShells.default = pkgs.mkShell.override { stdenv = env; } {
          packages =
            with pkgs;
            [
              clang-tools
              gnumake
            ]
            ++ buildInputs;
        };
      }
    );
}
