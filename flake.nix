{
  inputs = {
    # nixos-unstable provides latest packages while being somewhat
    # stable despite its name.
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    nightly.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs =
    {
      self,
      nightly,
      nixpkgs,
    }@inputs:
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
          base = pkgs.callPackage ./package.nix {
            neovim-unwrapped = inputs.nightly.packages.${pkgs.system}.default;
          };
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
                  vim-jinja
                  harpoon2
                  ;
              });
            extraBinaries = attrValues {
              inherit (pkgs.nodePackages_latest)
                prettier
                sql-formatter
                jsonlint
                ;
              inherit (pkgs)
                lua-language-server
                djlint
                jq
                yq
                rust-analyzer
                rustfmt
                tinymist
                ansible-lint
                typstyle
                typst-live
                nil
                deadnix
                statix
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
    };
}
