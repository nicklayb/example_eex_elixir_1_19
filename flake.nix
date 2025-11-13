{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }: 
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };

          PROJECT_ROOT = builtins.toString ./.;
        in
        {
          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [ 
              beamMinimal28Packages.elixir_1_19
              beamMinimal28Packages.erlang
              beamMinimal28Packages.elixir-ls
            ];

          shellHook = ''
            mkdir -p .nix-mix
            mkdir -p .nix-hex
            export MIX_HOME=./.nix-mix
            export HEX_HOME=./.nix-hex
          '';
          };
        }
      );
}
