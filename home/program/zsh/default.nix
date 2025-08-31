{
  enable = true;
  enableCompletion = true;
  autosuggestion = {
    enable = true;
  };
  history = {
    size = 50000;
    save = 50000;
  };
  shellAliases = {
    # Random passwords
    gen-pwd = "openssl rand -base64 32";
  };
  sessionVariables = {
    EDITOR = "hx";
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
