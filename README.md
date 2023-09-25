# Pure NixGL

[NixGL](https://github.com/guibou/nixGL) solves the OpenGL problem with nix.

But it is designed as an installable executable to wrap other commands
and, more importantly, its derivation is *impure*,
which makes it hard to use in flakes (e.g. [Home Manager](https://github.com/nix-community/home-manager)).

So I created this flake which, instead of providing an executable,
provides a Home Manager module that wraps a package to set up needed libraries and environment variables like NixGL does.

## Usage

1. Add the flake to your inputs:
  ```nix
  inputs = {
    pure-nixGL.url = "github:Dragonink/pure-nixGL";
  };
  ```
2. Import the module:
  ```nix
  home-manager.lib.homeManagerConfiguation {
    modules = [
      {
        imports = [
          pure-nixGL.homeManagerModules.pure-nixGL
        ];
      }
    ];
  }
  ```
3. Configure the module:
  ```nix
  {
    nixGL = {
      enable = true;

      driver = "mesa";
    };
  }
  ```
4. Wrap packages that use OpenGL with the provided `nixGL` function:
  ```nix
  { pkgs, nixGL, ... }: {
    programs.kitty = {
      package = nixGL pkgs.kitty;
    };
  }
  ```

## Module options

- **`driver`**: the driver to use.
  Possible values: `"mesa"`, `"nvidia"`. Required.
