{
  lib,
  org-babel-lib,
  twist-lib,
  rootPath,
  melpaSrc,
  elpaSrc,
  nongnuElpaSrc,
  pkgs,
  emacs,
  nativeCompileAheadDefault ? true,
}:

let
  initEl = lib.pipe (rootPath + "/init.org") [
    builtins.readFile
    (org-babel-lib.tangleOrgBabel {
    })
    (builtins.toFile "init.el")
  ];

  packageOverrides = _: prev: {
    elispPackages = prev.elispPackages.overrideScope (
      pkgs.callPackage ./packageOverrides.nix { inherit (prev) emacs; }
    );
  };
in
(twist-lib.makeEnv {
  inherit pkgs nativeCompileAheadDefault;
  emacsPackage = emacs;

  initFiles = [ initEl ];
  lockDir = rootPath + "/lock";
  initParser = twist-lib.parseSetup { inherit lib; } { };
  registries = import ./registries.nix {
    inherit
      rootPath
      melpaSrc
      elpaSrc
      nongnuElpaSrc
      ;
  };

  inputOverrides = import ./inputOverrides.nix { inherit rootPath lib; };

  initialLibraries = [
    "cl-lib"
    "jsonrpc"
    "let-alist"
    "map"
    "org"
    "seq"
  ];
  extraPackages = [
    "setup"
    "cl-lib"
  ];

  localPackages = [
    "lib-meow"
  ];
  # exportManifest = true;
}).overrideScope
  packageOverrides
