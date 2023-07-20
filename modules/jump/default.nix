{ stdenv, pkgs, lib }:

stdenv.mkDerivation {
  pname = "jump";
  version = "0.1.0";

  src = builtins.path {
    path = ./.;
  };

  buildInputs = [ pkgs.bash ];
  nativeBuildInputs = [ pkgs.makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp jump.sh $out/bin/jump
    wrapProgram $out/bin/jump \
        --prefix PATH : ${lib.makeBinPath [ pkgs.bash ]}
  '';
}
