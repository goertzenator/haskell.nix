{ system
  , compiler
  , flags
  , pkgs
  , hsPkgs
  , pkgconfPkgs
  , errorHandler
  , config
  , ... }:
  ({
    flags = { _regex-posix-clib = false; };
    package = {
      specVersion = "1.12";
      identifier = { name = "regex-posix"; version = "0.96.0.0"; };
      license = "BSD-3-Clause";
      copyright = "Copyright (c) 2007-2010, Christopher Kuklewicz";
      maintainer = "hvr@gnu.org";
      author = "Christopher Kuklewicz";
      homepage = "";
      url = "";
      synopsis = "POSIX Backend for \"Text.Regex\" (regex-base)";
      description = "The POSIX regex backend for <//hackage.haskell.org/package/regex-base regex-base>.\n\nThe main appeal of this backend is that it's very lightweight due to its reliance on the ubiquitous <https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/regex.h.html POSIX.2 regex> facility that is provided by the standard C library on most POSIX platforms.\n\nSee also <https://wiki.haskell.org/Regular_expressions> for more information.";
      buildType = "Simple";
    };
    components = {
      "library" = {
        depends = ([
          (hsPkgs."regex-base" or (errorHandler.buildDepError "regex-base"))
          (hsPkgs."base" or (errorHandler.buildDepError "base"))
          (hsPkgs."containers" or (errorHandler.buildDepError "containers"))
          (hsPkgs."bytestring" or (errorHandler.buildDepError "bytestring"))
          (hsPkgs."array" or (errorHandler.buildDepError "array"))
        ] ++ (if flags._regex-posix-clib
          then [
            (hsPkgs."regex-posix-clib" or (errorHandler.buildDepError "regex-posix-clib"))
          ]
          else pkgs.lib.optional (system.isWindows) (hsPkgs."base" or (errorHandler.buildDepError "base")))) ++ pkgs.lib.optional (!(compiler.isGhc && compiler.version.ge "8")) (hsPkgs."fail" or (errorHandler.buildDepError "fail"));
        buildable = true;
      };
    };
  } // {
    src = pkgs.lib.mkDefault (pkgs.fetchurl {
      url = "http://hackage.haskell.org/package/regex-posix-0.96.0.0.tar.gz";
      sha256 = "251300f1a6bb2e91abb8bf513a21981f8fab79c98a65acea2bb6d6a524414521";
    });
  }) // {
    package-description-override = "cabal-version:          1.12\nname:                   regex-posix\nversion:                0.96.0.0\nx-revision:             2\n\nbuild-type:             Simple\nlicense:                BSD3\nlicense-file:           LICENSE\ncopyright:              Copyright (c) 2007-2010, Christopher Kuklewicz\nauthor:                 Christopher Kuklewicz\nmaintainer:             hvr@gnu.org\nbug-reports:            https://github.com/hvr/regex-posix\nsynopsis:               POSIX Backend for \"Text.Regex\" (regex-base)\ncategory:               Text\ndescription:\n  The POSIX regex backend for <//hackage.haskell.org/package/regex-base regex-base>.\n  .\n  The main appeal of this backend is that it's very lightweight due to its reliance on the ubiquitous <https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/regex.h.html POSIX.2 regex> facility that is provided by the standard C library on most POSIX platforms.\n  .\n  See also <https://wiki.haskell.org/Regular_expressions> for more information.\n\nextra-source-files:\n  ChangeLog.md\n  cbits/myfree.h\n\ntested-with:\n  -- Haskell CI:\n  GHC == 7.0.4\n  GHC == 7.2.2\n  GHC == 7.4.2\n  GHC == 7.6.3\n  GHC == 7.8.4\n  GHC == 7.10.3\n  GHC == 8.0.2\n  GHC == 8.2.2\n  GHC == 8.4.4\n  GHC == 8.6.5\n  GHC == 8.8.4\n  GHC == 8.10.3\n  -- manually (AA, 2021-02-17):\n  -- GHC == 8.10.4\n  -- GHC == 9.0.1\n\nsource-repository head\n  type:     git\n  location: https://github.com/hvr/regex-posix.git\n\nsource-repository this\n  type:     git\n  location: https://github.com/hvr/regex-base.git\n  tag:      v0.96.0.0-r2\n\nflag _regex-posix-clib\n  manual: False\n  default: False\n  description: Use <//hackage.haskell.org/package/regex-posix-clib regex-posix-clib> package\n\nlibrary\n  hs-source-dirs: src\n  exposed-modules:\n      Text.Regex.Posix\n      Text.Regex.Posix.Wrap\n      Text.Regex.Posix.String\n      Text.Regex.Posix.Sequence\n      Text.Regex.Posix.ByteString\n      Text.Regex.Posix.ByteString.Lazy\n\n  other-modules:\n      Paths_regex_posix\n\n  c-sources:        cbits/myfree.c\n  include-dirs:     cbits\n\n  if flag(_regex-posix-clib)\n    build-depends: regex-posix-clib == 2.7.*\n  else\n    -- use POSIX.2 regex implementation from @libc@\n    -- However, Windows/msys2 doesn't provide a POSIX.2 regex impl in its @libc@\n    if os(windows)\n      build-depends: base<0\n\n  default-language: Haskell2010\n  default-extensions:\n      MultiParamTypeClasses\n      FunctionalDependencies\n      ForeignFunctionInterface\n      GeneralizedNewtypeDeriving\n      FlexibleContexts\n      TypeSynonymInstances\n      FlexibleInstances\n\n  build-depends: regex-base == 0.94.*\n               , base       >= 4.3 && < 4.16\n               , containers >= 0.4 && < 0.7\n               , bytestring >= 0.9 && < 0.12\n               , array      >= 0.3 && < 0.6\n\n  if !impl(ghc >= 8)\n      build-depends: fail == 4.9.*\n\n  ghc-options: -O2\n               -Wall -fno-warn-unused-imports\n";
  }