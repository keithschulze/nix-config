{ config, pkgs, lib, lsps ? ["pyright" "rust_analyzer" "terraformls"], extraPlugins ? [], ... }:

let
  lspString = "{ '" + (builtins.concatStringsSep "', '" lsps) + "' }";
  luaConfig = builtins.replaceStrings ["{{ servers }}"] [lspString] (lib.strings.fileContents ../../config/neovim/lsp.lua);

in {
  enable = true;
  extraConfig = builtins.concatStringsSep "\n" [
    (lib.strings.fileContents ../../config/neovim/base.vim)
    ''
      lua << EOF
      ${luaConfig}
      EOF
    ''
  ];

  withPython3 = true;

  extraPython3Packages = (ps: with ps; [jedi black]);

  plugins = with pkgs.vimPlugins; [
    vim-nix
    vim-repeat
    vim-fugitive
    vim-surround
    vim-dispatch
    vim-commentary

    vim-peekaboo
    vim-slash
    vim-startify
    fzf-vim
    gv-vim

    vim-gitgutter
    vim-easymotion
    vim-polyglot
    vim-rooter
    vim-tmux-navigator
    vim-bufkill

    nerdtree
    luasnip
    nvim-cmp
    cmp-nvim-lsp
    cmp_luasnip

    # Style
    nord-vim
    tokyonight-nvim
    # airline
    lightline-vim
    vim-airline-themes

    # LSP
    nvim-lspconfig

    # plant-uml
    plantuml-syntax
    open-browser
  ] ++ extraPlugins;
}
