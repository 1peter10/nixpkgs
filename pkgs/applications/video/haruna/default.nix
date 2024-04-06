{ lib
, fetchFromGitLab
, mkKdeDerivation
, breeze-icons
, breeze
, cmake
, extra-cmake-modules
, ffmpeg-headless
, kconfig
, kcoreaddons
, kfilemetadata
, ki18n
, kiconthemes
, kio
, kirigami
, kxmlgui
, kdoctools
, mpv
, pkg-config
, wrapQtAppsHook
, qqc2-desktop-style
, qtbase
, yt-dlp
}:

mkKdeDerivation rec {
  pname = "haruna";
  version = "1.0.2";

  src = fetchFromGitLab {
    owner = "multimedia";
    repo = "haruna";
    rev = "v${version}";
    hash = "sha256-L/mTFPJPHl8A6FqkWUwICh+Yl4uIE5KnTkZVnC4kCZ8=";
    domain = "invent.kde.org";
  };

  postPatch = ''
    substituteInPlace src/application.cpp \
      --replace '"yt-dlp"' '"${lib.getExe yt-dlp}"'
  '';

  buildInputs = [
    breeze-icons
    breeze
    qqc2-desktop-style
    yt-dlp

    ffmpeg-headless
    kconfig
    kcoreaddons
    kfilemetadata
    ki18n
    kiconthemes
    kio
    kirigami
    kxmlgui
    kdoctools
    mpv
    qtbase
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
    wrapQtAppsHook
  ];

  meta = with lib; {
    homepage = "https://invent.kde.org/multimedia/haruna";
    description = "Open source video player built with Qt/QML and libmpv";
    license = with licenses; [ bsd3 cc-by-40 cc-by-sa-40 cc0 gpl2Plus gpl3Plus wtfpl ];
    maintainers = with maintainers; [ jojosch kashw2 ];
    mainProgram = "haruna";
  };
}
