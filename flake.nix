{
  description = "A pure version of NixGL for Home Manager";

  outputs = { ... }: {
    homeManagerModules = rec {
      pure-nixGL = import ./module.nix;
      default = pure-nixGL;
    };
  };
}
