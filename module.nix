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
    nvidiaVersion = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Version of the Nvidia driver";
    };
  };

  config._module.args = lib.mkIf cfg.enable {
    nixGL = pkg: pkgs.callPackage ./nixGL.nix {
      inherit pkg;
      inherit (cfg) driver nvidiaVersion;
    };
  };
}
