{
  stdenv,
  pkg-config,
  enchant2,
  ...
}:

_final: prev: {

  devdocs = prev.devdocs.overrideAttrs (_: {
    preBuild = ''
      substituteInPlace devdocs.el --replace-fail "(require 'mathjax)" "(require 'mathjax nil t)"
    '';
  });

  jinx = prev.jinx.overrideAttrs (
    old:
    let
      moduleSuffix = stdenv.targetPlatform.extensions.sharedLibrary;
    in
    {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkg-config ];
      buildInputs = (old.buildInputs or [ ]) ++ [ enchant2 ];

      preBuild = ''
        NIX_CFLAGS_COMPILE="$($PKG_CONFIG --cflags enchant-2) $NIX_CFLAGS_COMPILE"
        $CC -I. -O2 -fPIC -shared -o jinx-mod${moduleSuffix} jinx-mod.c -lenchant-2
        rm *.c *.h
      '';
    }
  );

  magit = prev.magit.overrideAttrs (old: {
    preBuild = ''
      substituteInPlace Makefile --replace "include ../default.mk" ""
      make PKG=magit VERSION="${old.version}" magit-version.el
      sed -i -e "1i ;;; -*- lexical-binding: t; -*-" magit-version.el
      rm Makefile
    '';
  });

  #nov = prev.nov.overrideAttrs (old: {
  #  propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ unzip ];
  #});

}
