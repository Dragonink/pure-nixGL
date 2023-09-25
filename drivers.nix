{
  driver,

  mesa, linuxPackages,
}: if driver == "mesa" then rec {
  dri = mesa.drivers;
  lib = dri;
} else if driver == "nvidia" then rec {
  dri = linuxPackages.nvidia_x11.overrideAttrs ({ name, ... }: {
    name = "nixGL-${name}";
    useGLVND = true;
  });
  lib = dri.override {
    libsOnly = true;
    kernel = null;
  };
} else abort "invalid `nixGL.driver` value"
