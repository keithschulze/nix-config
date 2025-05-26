{ stdenv, pkgs }:

stdenv.mkDerivation {
  name = "aws-auth";
  version = "0.2.4";

  src = builtins.fetchGit {
    url = "git@github.com:SEEK-Jobs/aws-auth-bash.git";
    rev = "af11ed6fb2aa9b5eb681f1a5552992f0844d7990";
  };

  buildInputs = with pkgs; [
    bash
    jq
    curl
    awscli2
  ];

  nativeBuildInputs = with pkgs; [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp auth.sh $out/bin/aws-auth
    wrapProgram $out/bin/aws-auth \
        --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.bash pkgs.jq pkgs.curl pkgs.awscli2 ]}
  '';

  meta = {
    homepage = "https://github.com/SEEK-Jobs/aws-auth-bash";
    description = "A SEEK tool for authenticating with AWS.";
    mainProgram = "aws-auth";
  };
}
