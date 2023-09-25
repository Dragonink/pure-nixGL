{
  pkg,
  driver,

  lib, runCommand, makeWrapper,
  libglvnd, libvdpau-va-gl,
  mesa, linuxPackages,
}:
let
  drivers = import ./drivers.nix { inherit driver mesa linuxPackages; };
in runCommand "nixGL-${driver}-${pkg.name}" rec {
  nativeBuildInputs = [ makeWrapper ];

  EXE_PATH = lib.getExe pkg;
  EXE_NAME = lib.last (lib.splitString "/" EXE_PATH);
} ''
  mkdir --parents $out/bin
  makeWrapper $EXE_PATH $out/bin/$EXE_NAME \
    --inherit-argv0 \
    --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [
      libglvnd
      drivers.lib
    ]}:${lib.makeSearchPathOutput "lib" "lib/vdpau" [ libvdpau-va-gl ]}" \
    --prefix LIBGL_DRIVERS_PATH : "${lib.makeSearchPathOutput "lib" "lib/dri" [ drivers.dri ]}" \
    --prefix LIBVA_DRIVERS_PATH : "${lib.makeSearchPathOutput "out" "lib/dri" [ drivers.dri ]}" \
    --prefix __EGL_VENDOR_LIBRARY_FILENAMES : "${lib.concatStringsSep ":" (builtins.attrNames (builtins.readDir "${drivers.dri}/share/glvnd/egl_vendor.d"))}"
''
