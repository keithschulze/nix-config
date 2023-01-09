{ config, pkgs, lib, lsps ? ["pyright" "rust_analyzer" "terraformls"], extraPlugins ? [], ... }:

let
  lspString = "{ '" + (builtins.concatStringsSep "', '" lsps) + "' }";
  luaConfig = builtins.replaceStrings ["{{ servers }}"] [lspString] (lib.strings.fileContents ./lsp.lua);

in {
  enable = true;
  extraConfig = builtins.concatStringsSep "\n" [
    (lib.strings.fileContents ./base.vim)
    ''
      lua << EOF
      ${luaConfig}
      EOF
    ''
  ];

  withPython3 = true;

  extraPython3Packages = (ps: with ps; [jedi]);

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
    gv-vim

    vim-gitgutter
    vim-easymotion
    vim-polyglot
    vim-rooter
    vim-tmux-navigator
    vim-bufkill

    telescope-nvim
    telescope-fzf-native-nvim

    nerdtree
    luasnip
    nvim-cmp
    cmp-nvim-lsp
    cmp_luasnip
    (nvim-treesitter.withPlugins (plugins: [
      plugins.tree-sitter-rust
      plugins.tree-sitter-python
      plugins.tree-sitter-clojure
      plugins.tree-sitter-nix
      plugins.tree-sitter-scala
      plugins.tree-sitter-dockerfile
      plugins.tree-sitter-hcl
      plugins.tree-sitter-javascript
      plugins.tree-sitter-json
      plugins.tree-sitter-markdown
      plugins.tree-sitter-sql
      plugins.tree-sitter-typescript
      plugins.tree-sitter-yaml
    ]))
    plenary-nvim

    # Style
    nord-vim
    tokyonight-nvim
    # airline
    lightline-vim
    vim-airline-themes

    # LSP
    nvim-lspconfig
    nvim-metals

    # plant-uml
    plantuml-syntax
    open-browser
  ] ++ extraPlugins;
}
