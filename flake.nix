{
  description = "A flake for ragons dwl fork";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
  flake-utils.lib.eachDefaultSystem(system: 
  let pkgs = nixpkgs.legacyPackages.${system}; in
  rec {

    packages = flake-utils.lib.flattenTree {
      dwl = pkgs.dwl.overrideAttrs ( oldAttrs: rec {
        buildInputs = oldAttrs.buildInputs ++ [ pkgs.harfbuzz ];
        src = ./.;
      });
    };
    defaultPackage = packages.dwl;
    apps.dwl = flake-utils.lib.mkApp { drv = packages.dwl; };
    defaultApp = apps.dwl;
    devShell = pkgs.mkShell {
      buildInputs = with pkgs; [ 
        libinput
        xorg.libxcb
        libxkbcommon
        pixman
        wayland
        wayland-protocols
        wlroots
        xorg.libX11
        xwayland
      ];
      nativeBuildInputs = with pkgs; [ pkg-config ];

    };
  });
}
