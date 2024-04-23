{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation (finalAttrs: {
  pname = "jsoncons";
  version = "0.174.0";

  src = fetchFromGitHub {
    owner = "danielaparker";
    repo = "jsoncons";
    rev = "v${finalAttrs.version}";
    hash = "sha256-VL64oWmaLz4zJm8eCF03tcAkeL+j1BRAQJ5/kUA7L90=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "A C++, header-only library for constructing JSON and JSON-like data formats";
    homepage = "https://danielaparker.github.io/jsoncons/";
    changelog = "https://github.com/danielaparker/jsoncons/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = licenses.boost;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.all;
  };
})
