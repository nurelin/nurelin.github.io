+++
title = "Nix Trick: Passing Flake's Inputs To NixOS"
date = 2021-09-10
[taxonomies]
tags = [ "nix", "flake" ]
categories = [ ]
+++

With Nix's [Flake](https://nixos.wiki/wiki/Flakes) being the future of nix and a better solution than the current combo of NIX_PATH/nix-channel.
I refactored my NixOS configuration but often needed a way to pass flake's inputs to nixos configurations top modules.

After digging a bit in the nixos build system, I found that [`SpecialArgs`](https://github.com/NixOS/nixpkgs/blob/a6fbb0b67ddf15f495c3fff0a05beb7885759863/lib/modules.nix#L65-L69) can be used to pass arbitrary arguments to modules.

```nix
# flake.nix
{
  description = "NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.05";
    nixos-hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = { self, nixpkgs, nixos-hardware, ... }@args: {
    nixosConfigurations = {
      t250 = nixpkgs.lib.nixosSystem {
        specialArgs = {
          flakeInputs = args;
        };
        
        imports = [
          ./t250.nix
        ];
      };
    };
  };
}

# t250.nix;
{ flakeInputs, ... }:
{
  imports = [
    flakeInputs.nixos-hardware.nixosModules.lenovo-thinkpad-x250
  ];
}
```

<!-- more -->
