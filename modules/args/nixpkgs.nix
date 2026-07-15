# globally instruct  flake-parts  to allow unfree packages inside the  perSystem  outputs
{inputs, ...}: {
  perSystem = {system, ...}: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
  };
}
