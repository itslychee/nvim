{
  # Neovim
  vimUtils,
  vimPlugins,
  neovimUtils,
  neovim-unwrapped,
  wrapNeovimUnstable,
  lib,
  # third party programs
  ripgrep,
  nixfmt-rfc-style,
  nil,
  # Extend the base derivation
  grammars ? vimPlugins.nvim-treesitter.withAllGrammars,
  extraPlugins ? [],
  extraBinaries ? [],
  ...
}: let
  inherit (lib) flatten makeBinPath;
  config = neovimUtils.makeNeovimConfig {
    plugins = lib.singleton (
      vimUtils.buildVimPlugin {
        name = "fruit-nvim-config";
        src = ./nvim;
        dependencies = flatten (
          builtins.attrValues {
            inherit
              (vimPlugins)
              # nvim-cmp, autocompletion stuffs
              
              cmp-async-path
              cmp-buffer
              cmp-cmdline
              cmp-nvim-lsp
              nvim-cmp
              luasnip
              # LSPs
              
              nvim-lspconfig
              # Formatting
              
              conform-nvim
              # misc
              
              mini-nvim
              nvim-ts-context-commentstring
              # conveniences
              
              lualine-nvim
              ;
            inherit extraPlugins;
            inherit grammars;
          }
        );
      }
    );
    wrapRc = false;
  };
in
  (wrapNeovimUnstable neovim-unwrapped config).overrideAttrs (prev: {
    generatedWrapperArgs =
      (prev.generatedWrapperArgs or [])
      ++ [
        "--suffix"
        "PATH"
        ":"
        (makeBinPath (flatten [
          (builtins.trace extraBinaries extraBinaries)
          # binaries that are convenient :3
          ripgrep
          nil
          nixfmt-rfc-style
        ]))
      ];
  })
