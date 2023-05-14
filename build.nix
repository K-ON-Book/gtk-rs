{ rustPlatform
, pkg-config
, stdenv
, openssl
, gtk4
, glib
}:

rustPlatform.buildRustPackage rec {
  pname = "my_gui";
  version = "0.1.0";

  src = ./.;
  cargoLock = {
    lockFile = ./Cargo.lock;
  };
  nativeBuildInputs = [
    pkg-config
    openssl
  ];

  buildInputs = [
    gtk4
  ];

}
