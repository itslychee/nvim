{
  inputs = {
    # nixos-unstable provides latest packages while being somewhat
    # stable despite its name.
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    typhon.url = "github:itslychee/typhon?ref=itslychee/random-fixes-and-additions";
  };

  outputs =
    {
      self,
      nixpkgs,
      typhon,
    }:
    let
      inherit (nixpkgs.lib) genAttrs;
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      eachSystem = f: genAttrs systems (arch: f nixpkgs.legacyPackages.${arch});
    in
    {
      # Packages go here
      packages = eachSystem (
        pkgs:
        let
          inherit (builtins) attrValues;
        in
        rec {
          #
          base = pkgs.callPackage ./package.nix { };
          full = minimal.override (prev: {
            extraPlugins =
              prev.extraPlugins
              ++ (attrValues {
                inherit (pkgs.vimPlugins)
                  which-key-nvim
                  nvim-web-devicons
                  nvim-colorizer-lua
                  git-conflict-nvim
                  vim-fugitive
                  typescript-tools-nvim
                  ;
              });
            extraBinaries = attrValues {
              inherit (pkgs.nodePackages_latest)
                prettier
                sql-formatter
                ;
              inherit (pkgs)
                djlint
                jq
                typst-lsp
                typstyle
                typst-live
                ;

            };
          });
          minimal = base.override (prev: {
            treesitter = pkgs.vimPlugins.nvim-treesitter.withGrammars (ps: [
              ps.nix
              ps.bash
            ]);
            extraPlugins = attrValues {
              inherit (pkgs.vimPlugins) kanagawa-nvim;
            };
          });
          default = full;
        }
      );

      devShells = eachSystem (pkgs: {
        default = pkgs.mkShell {
          packages = [ pkgs.stylua ];
        };
      });
      # Formatter
      formatter = eachSystem (pkgs: pkgs.nixfmt-rfc-style);
      typhonJobs = self.packages;
      typhonProject = typhon.lib.github.mkProject {
        owner = "itslychee";
        repo = "nvim";
        secrets = ./secrets.age;
        typhonUrl = "https://ci.wires.cafe";
        deploy = [
          {
            name = "Push to Attic";
            value = typhon.lib.attic.mkPush {
              endpoint = "https://cache.wires.cafe";
              cache = "lychee-config";
            };
          }
        ];
      };
    };
}
