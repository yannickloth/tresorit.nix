{}:

with import <nixpkgs> {};

stdenv.mkDerivation rec {

  version = "3.5.938.2150";
  name = "tresorit-${version}";

  src = fetchurl {
    url = https://installerstorage.blob.core.windows.net/public/install/tresorit_installer.run;
    sha256 = "0m83zb59v1fkyrc9lkyggiifcrh5mfxg579bk8512szypn7m83mp";
  };

  runtimeDependencies = [ fuse ];
  dontPatchELF = true;
  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ xorg.libXext
                  xorg.libxcb
                  xorg.libX11
                  libGL ];
  dontBuild = true;
  dontConfigure = true;
  dontMake = true;

  unpackPhase  = ''
    export `grep -a SKIP $src | head -n 1`
    tail -n+$SKIP $src | tar xz -C $TMP
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -rf $TMP/tresorit_x64/* $out/bin/
    rm $out/bin/uninstall.sh
  '';

  meta = with lib; {
    description = "Tresorit is the ultra-secure place in the cloud to store, sync and share files easily from anywhere, anytime.";
    homepage = https://tresorit.com;
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = [ maintainers.apeyroux ];
  };
}
