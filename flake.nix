{
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-21.11;
    utils.url = github:numtide/flake-utils;
    personal.url = git+https://code.akitaki.tk/nix-packages.git;
  };

  outputs = { self, nixpkgs, personal, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        # Note: this package only works on my machine.
        vivado = pkgs.buildFHSUserEnv {
          name = "vivado";
          targetPkgs = pkgs: (
            with pkgs; [
              ncurses5
              zlib
              libuuid
              bash
              coreutils
              zlib
              stdenv.cc.cc
              ncurses
              xorg.libXext
              xorg.libX11
              xorg.libXrender
              xorg.libXtst
              xorg.libXi
              xorg.libXft
              xorg.libxcb
              xorg.libxcb
              freetype
              fontconfig
              glib
              gtk2
              gtk3
              graphviz
              gcc
              unzip
              nettools
            ]
          );
          runScript = ''
            env LIBRARY_PATH=/usr/lib \
            C_INCLUDE_PATH=/usr/include \
            CPLUS_INCLUDE_PATH=/usr/include \
            CMAKE_LIBRARY_PATH=/usr/lib \
            CMAKE_INCLUDE_PATH=/usr/include \
            /home/akitaki/xilinx/Vivado/2020.2/bin/vivado "$@"
          '';
        };
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            # nix dev
            rnix-lsp
            nixpkgs-fmt
            # verilog dev
            verilog
            personal.packages.${system}.svls
            personal.packages.${system}.sv2v
            verilator
            # CPP dev
            clang-tools
            bear
            criterion
            # Python dev
            python3
            python3Packages.ipython
            python3Packages.numpy
            pyright
            # Fpga programming
            openocd
            vivado
          ];
          CRITERION_INCLUDE_PATH = "${pkgs.criterion}/include";
        };
      });
}
