{ config, pkgs, lib, ... }:

let
  vim-zettel = pkgs.vimUtils.buildVimPlugin {
    name = "vim-zettel";
    src = pkgs.fetchFromGitHub {
      owner = "michal-h21";
      repo = "vim-zettel";
      rev = "5f046caa2044d2ecd08ff0ce7aa0e73d70a77e50";
      sha256 = "0jrwirz6dhhd4mhrw5vvkdvfhla22hcmxfgxbqdcl272cgpplg5x";
    };
  };
in {
  enable = true;
  extraConfig = builtins.concatStringsSep "\n" [
    (lib.strings.fileContents ../../config/neovim/base.vim)
    ''
      lua << EOF
      ${lib.strings.fileContents ../../config/neovim/lsp.lua}
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

    vimwiki
    vim-zettel
  ];
}
