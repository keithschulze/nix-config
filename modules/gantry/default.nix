{ stdenv, pkgs }:

stdenv.mkDerivation rec {
  name = "gantry";
  version = "4.1.0";

  src = builtins.fetchGit {
    url = "git@github.com:SEEK-Jobs/gantry.git";
    rev = "11f29bc7906a9b01b373342e35178594d293ec60";
  };

  buildInputs = with pkgs; [
    git
    go
  ];

  buildPhase = ''
    make gobuild BINARIES=darwin/arm64/gantry VERSION=${version} GOPATH=$out/share/go GOCACHE=$out/go-cache
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bin/release/darwin/arm64/gantry $out/bin
  '';

  meta = {
    homepage = "https://github.com/SEEK-Jobs/gantry";
    description = "A SEEK tool for toolchain for deploying containers to AWS.";
    mainProgram = "gantry";
  };
}
