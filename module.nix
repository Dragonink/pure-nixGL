{ config, lib, pkgs, ... }:
let
  cfg = config.nixGL;
in {
  options.nixGL = with lib; {
    enable = mkEnableOption "nixGL";

    driver = mkOption {
      type = types.enum [ "mesa" "nvidia" ];
      description = "The driver to use";
    };
  };

  config._module.args = lib.mkIf cfg.enable {
    nixGL = pkg: pkgs.callPackage ./nixGL.nix {
      inherit pkg;
      inherit (cfg) driver;
    };
  };
}
