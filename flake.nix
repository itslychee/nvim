{
  inputs = {
    # nixos-unstable provides latest packages while being somewhat
    # stable despite its name.
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
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
                  ;
              });
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

      # Formatter
      formatter = eachSystem (pkgs: pkgs.nixfmt-rfc-style);
    };
}
