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
  extraPlugins ? [ ],
  extraBinaries ? [ ],
  ...
}:
let
  inherit (lib) flatten makeBinPath;
  config = neovimUtils.makeNeovimConfig {
    plugins = lib.singleton (
      vimUtils.buildVimPlugin {
        name = "fruit-nvim-config";
        src = ./nvim;
        doCheck = false;
        dependencies = flatten (
          builtins.attrValues {
            inherit (vimPlugins)
              # nvim-cmp, autocompletion stuffs
              cmp-async-path
              cmp-buffer
              cmp-cmdline
              cmp-nvim-lsp
              nvim-cmp
              # blink-cmp
              friendly-snippets
              vim-gnupg
              # LSPs
              nvim-lspconfig
              # Formatting
              conform-nvim
              # misc
              mini-nvim
              nvim-lint
              # nvim-ts-context-commentstring
              # conveniences
              fidget-nvim
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
((wrapNeovimUnstable neovim-unwrapped config).overrideAttrs {
  runtimeDeps = (
    flatten [
      extraBinaries
      # binaries that are convenient :3
      ripgrep
      nil
      nixfmt-rfc-style
    ]
  );
})
