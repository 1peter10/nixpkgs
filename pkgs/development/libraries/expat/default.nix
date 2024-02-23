{ lib
, stdenv
, fetchurl
# for passthru.tests
, python3
, perlPackages
, haskellPackages
, luaPackages
, ocamlPackages
, testers
}:

# Note: this package is used for bootstrapping fetchurl, and thus
# cannot use fetchpatch! All mutable patches (generated by GitHub or
# cgit) that are needed here should be included directly in Nixpkgs as
# files.

stdenv.mkDerivation (finalAttrs: {
  pname = "expat";
  version = "2.6.0";

  src = fetchurl {
    url = with finalAttrs; "https://github.com/libexpat/libexpat/releases/download/R_${lib.replaceStrings ["."] ["_"] version}/${pname}-${version}.tar.xz";
    hash = "sha256-y19ajqIR4cq9Wb4KkzpS48Aswyboak04fY0hjn7kej4=";
  };

  patches = [
    # Fix tests flakiness on some platforms (like aarch64-darwin), should be released in 2.6.1
    ./2.6.0-fix-tests-flakiness.patch
  ];

  strictDeps = true;

  outputs = [ "out" "dev" ]; # TODO: fix referrers
  outputBin = "dev";

  enableParallelBuilding = true;

  configureFlags = lib.optional stdenv.isFreeBSD "--with-pic";

  outputMan = "dev"; # tiny page for a dev tool

  doCheck = true; # not cross;

  preCheck = ''
    patchShebangs ./run.sh ./test-driver-wrapper.sh
  '';

  # CMake files incorrectly calculate library path from dev prefix
  # https://github.com/libexpat/libexpat/issues/501
  postFixup = ''
    substituteInPlace $dev/lib/cmake/expat-${finalAttrs.version}/expat-noconfig.cmake \
      --replace "$"'{_IMPORT_PREFIX}' $out
  '';

  passthru.tests = {
    inherit python3;
    inherit (python3.pkgs) xmltodict;
    inherit (haskellPackages) hexpat;
    inherit (perlPackages) XMLSAXExpat XMLParser;
    inherit (luaPackages) luaexpat;
    inherit (ocamlPackages) ocaml_expat;
    pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
    };
  };

  meta = with lib; {
    changelog = "https://github.com/libexpat/libexpat/blob/${tag}/expat/Changes";
    homepage = "https://libexpat.github.io/";
    description = "A stream-oriented XML parser library written in C";
    platforms = platforms.all;
    license = licenses.mit; # expat version
    pkgConfigModules = [ "expat" ];
  };
})
