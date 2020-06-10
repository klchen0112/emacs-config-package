{ version ? "dev", stdenv, trivialBuild }:

let
  filteredSrc = let filter = name: type: type != "symlink";
  in builtins.filterSource filter ./.;
in stdenv.mkDerivation rec {
  pname = "emacs-config";
  inherit version;

  src = filteredSrc;
  dontUnpack = true;

  init = trivialBuild {
    pname = "config-init";
    inherit version src;

    preBuild = ''
      # Tangle org files
      emacs --batch -Q \
        *.org \
        -f org-babel-tangle

      # Fake config directory in order to have files on load-path
      mkdir -p .xdg-config
      ln -s $PWD .xdg-config/emacs
      export XDG_CONFIG_HOME="$PWD/.xdg-config"
    '';
  };

  lisp = trivialBuild {
    pname = "config-lisp";
    src = "${src}/lisp";
    inherit version;
  };

  installPhase = ''
    lispDir=$out/lisp

    install -d $out
    install ${init}/share/emacs/site-lisp/* $out/.
    install -d $lispDir
    install ${lisp}/share/emacs/site-lisp/* $lispDir/.

    cp -r $src/snippets $out/.
    cp -r $src/templates $out/.
  '';
}
