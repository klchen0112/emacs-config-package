{ stdenv, fetchFromGitHub, writeText, texinfo, perl, which }:

self: super:

with super;

{
  # Fix code actions when using javascript-typescript-langserver.
  jsonrpc = let
    src = jsonrpc.src;
    patch = ./patches/jsonrpc.patch;
    patchedSrc = stdenv.mkDerivation {
      name = "emacs-${jsonrpc.pname}-${jsonrpc.version}-patched.el";
      inherit src;
      phases = [ "patchPhase" ];
      patchPhase = "patch $src -o $out < ${patch}";
    };
  in elpaBuild rec {
    inherit (jsonrpc) pname ename version meta;
    src = patchedSrc;
    packageRequires = [ emacs ];
  };

  # Personal forks.
  flymake-diagnostic-at-point = flymake-diagnostic-at-point.overrideAttrs
    (attrs: {
      version = "20190810.2232";
      src = fetchFromGitHub {
        owner = "terlar";
        repo = "flymake-diagnostic-at-point";
        rev = "8a4f5c1160cbb6c2464db9f5c104812b0c0c6d4f";
        sha256 = "17hkqspg2w1yjlcz3g6kxxrcz13202a1x2ha6rdp4f1bgam5lhzq";
        # date = 2019-08-10T22:32:04+02:00;
      };
    });

  org = stdenv.mkDerivation rec {
    pname = "emacs-org";
    version = "20200521.856";

    src = fetchFromGitHub {
      owner = "terlar";
      repo = "org-mode";
      rev = "bf42cf9bbf019fe915e90cb2b86b7be42a7e00de";
      sha256 = "067l1l2dif8fnqlvvxbdarsj6v0lb1jyw0gdpr09k9b7iix7mc7a";
      # date = 2020-05-21T08:56:03+02:00;
    };

    preBuild = ''
      makeFlagsArray=(
        prefix="$out/share"
        ORG_ADD_CONTRIB="org* ox*"
        GITVERSION="${version}"
        ORGVERSION="${version}"
                                       );
    '';

    preInstall = ''
      perl -i -pe "s%/usr/share%$out%;" local.mk
    '';

    buildInputs = [ emacs texinfo perl which ];

    meta = with stdenv.lib; {
      homepage = "https://elpa.gnu.org/packages/org.html";
      license = licenses.free;
    };
  };

  # Packages not in MELPA.
  apheleia = melpaBuild rec {
    pname = "apheleia";
    version = "20200510.1032";
    src = fetchFromGitHub {
      owner = "raxod502";
      repo = "apheleia";
      rev = "3e342632b834a78f31ead48b94392e00dba1542c";
      sha256 = "1cq1rcg1hzc9szynci5rl7pp3fi7i5kq35jy60cfa9aymmxgvi76";
      # date = 2020-05-10T10:32:04-06:00;
    };
    recipe = writeText "recipe" ''(${pname} :repo "x" :fetcher github)'';
  };

  eglot-x = melpaBuild rec {
    pname = "eglot-x";
    version = "20200104.1435";
    src = fetchFromGitHub {
      owner = "nemethf";
      repo = "eglot-x";
      rev = "910848d8d6dde3712a2a2610c00569c46614b1fc";
      sha256 = "0sl6k5y3b855mbix310l9xzwqm4nb8ljjq4w7y6r1acpfwd7lkdc";
      # date = 2020-01-04T14:35:35+01:00;
    };
    recipe = writeText "recipe" ''(${pname} :repo "x" :fetcher github)'';
  };

  ejira = melpaBuild rec {
    pname = "ejira";
    version = "20200206.2144";
    src = fetchFromGitHub {
      owner = "nyyManni";
      repo = "ejira";
      rev = "89f7c668caf0e46e929f2c9187b007eed6b5c229";
      sha256 = "0a97gx016byiy5fri8jf3x3sfd2h2iw79s6nxv9jigpkgxrkjg7b";
      # date = 2020-02-06T21:44:57+02:00;
    };
    recipe = writeText "recipe" ''(${pname} :repo "x" :fetcher github) '';
    packageRequires = [ org s f ox-jira dash jiralib2 language-detection ];
  };

  eldoc-posframe = melpaBuild rec {
    pname = "eldoc-posframe";
    version = "20190209.1123";
    src = fetchFromGitHub {
      owner = "terlar";
      repo = "eldoc-posframe";
      rev = "2e012a097dfab66a05a858b1486bba9f70956823";
      sha256 = "1pn1g8mwcgxpavwj9z8rr244pak3n7jqbswjav5bni89s4wm9rhz";
      # date = 2019-02-09T11:23:21+01:00;
    };
    recipe = writeText "recipe" ''(${pname} :repo "x" :fetcher github) '';
  };

  explain-pause-mode = melpaBuild rec {
    pname = "explain-pause-mode";
    version = "20200520.1657";
    src = fetchFromGitHub {
      owner = "lastquestion";
      repo = "explain-pause-mode";
      rev = "5398439abe1f075f43bea1dfad6c56f8412d681a";
      sha256 = "1f34pml5jsn0ihmxas5bj00mznx8wl12kpqmf9fc51jch1w5yyas";
      # date = 2020-05-20T16:57:51-07:00;
    };
    recipe = writeText "recipe" ''(${pname} :repo "x" :fetcher github)'';
  };

  ivy-ghq = melpaBuild rec {
    pname = "ivy-ghq";
    version = "20191231.1957";
    src = fetchFromGitHub {
      owner = "analyticd";
      repo = "ivy-ghq";
      rev = "78a4cd32a7d7556c7c987b0089ea354e41b6f901";
      sha256 = "1ddpdhg26nhqdd30k36c3mkciv5k2ca7vqmy3q855qnimir97zxz";
      # date = 2019-12-31T19:57:04-08:00;
    };
    recipe = writeText "recipe" ''(${pname} :repo "x" :fetcher github)'';
  };

  org-pretty-table = melpaBuild rec {
    pname = "org-pretty-table";
    version = "20200329.1831";
    src = fetchFromGitHub {
      owner = "fuco1";
      repo = "org-pretty-table";
      rev = "88380f865a79bba49e4f501b7fe73a7bfb03bd1a";
      sha256 = "0kynnja58r9cwfrxxyycg6z4hz9s5rzgn47i9yki7rlr80nyn2bf";
      # date = 2020-03-29T18:31:18+02:00;
    };
    recipe = writeText "recipe" ''(${pname} :repo "x" :fetcher github)'';
  };

  source-peek = melpaBuild rec {
    pname = "source-peek";
    version = "20170424.347";
    src = fetchFromGitHub {
      owner = "iqbalansari";
      repo = "emacs-source-peek";
      rev = "fa94ed1def1e44f3c3999d355599d1dd9bc44dab";
      sha256 = "14ai66c7j2k04a0vav92ybaikcc8cng5i5vy0iwpg7b2cws8a2zg";
      # date = 2017-04-24T03:47:10+05:30;
    };
    recipe = writeText "recipe" ''(${pname} :repo "x" :fetcher github)'';
  };
}
