
let
  # npins stuff
  sources = import ./npins;
in
import "${sources.nixpkgs}/nixos" {
  # literally just point to your nixos config (unchanged)
  configuration = ./nixos/configuration.nix;
}
