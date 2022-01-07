{
  enable = true;
  enableCompletion = true;
  enableAutosuggestions = true;
  history = {
    size = 50000;
    save = 50000;
  };
  shellAliases = {
    vw = "nvim -c VimwikiIndex";
    mux="tmuxinator";
    # Random passwords
    gen-pwd = "openssl rand -base64 32";
  };
  sessionVariables = rec {
    EDITOR = "nvim";
    FZF_DEFAULT_COMMAND = "rg --files --no-ignore-vcs --hidden";
    CC = "clang";
  };
  oh-my-zsh = {
    enable = true;
    plugins = [
      "git"
      "vi-mode"
      "docker-compose"
      "ripgrep"
      "tmux"
    ];
  };
}
