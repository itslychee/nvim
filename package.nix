{
  # Neovim
  vimUtils,
  vimPlugins,
  neovimUtils,
  neovim-unwrapped,
  wrapNeovimUnstable,
  writeText,
  lib,
  # third party programs
  ripgrep,
  nixfmt-rfc-style,
  nil,
  # Extend the base derivation
  grammars ? vimPlugins.nvim-treesitter.withAllGrammars,
  extraPlugins ? [ ],
  extraBinaries ? [ ],
  debug ? false,
  ...
}:
let
  inherit (lib) flatten;
  plugins = lib.flatten [
    (builtins.attrValues {
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
        nvim-ts-autotag
        nvim-lint
        nvim-ts-context-commentstring
        # conveniences
        fidget-nvim
        lualine-nvim
        ;
      inherit extraPlugins;
      inherit grammars;
    })
    (
      if !debug then
        vimUtils.buildVimPlugin {
          name = "fruit-nvim-config";
          src = ./nvim;
          doCheck = false;
        }
      else
        [ ]
    )
  ];

  luaRcContent =
    if debug then
      ''
        vim.opt.rtp:prepend(vim.uv.cwd() .. "/nvim")
        require("fruit")
      ''
    else
      "";

  wrapRc = debug;
in
(wrapNeovimUnstable neovim-unwrapped {
  inherit luaRcContent wrapRc plugins;
}).overrideAttrs
  {

    runtimeDeps = flatten [
      extraBinaries
      # binaries that are convenient :3
      ripgrep
      nil
      nixfmt-rfc-style
    ];
  }
