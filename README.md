# config.nix

My personal Nix configuration for managing multiple hosts and programs across NixOS, nix-darwin, and home-manager environments.

This repo follows the dendritic pattern using [flake-parts](https://github.com/hercules-ci/flake-parts), where each feature/setting is encapsulated in its own file or module and then composed into full-featured system configurations.

## Flake Outputs

| Output | Location |
|---|---|
| `{nixos,darwin}Configuration` | `./modules/hosts` |
| `homeConfiguration` | `./modules/users` |
| `modules` | `./modules` |

### Modules

All feature sets used across my system configurations, exported through the flake module system.

### Custom Packages

Standalone packages and scripts available directly via `nix run`.

| Package | Description | Run |
|---|---|---|
| `nvim` | Neovim nightly wrapped with my nixvim config | `nix run github:MorganKF/config.nix#nvim` |
| `write-flake` | Update flake.nix inputs | `nix run .#write-flake` |

## Resources

- [NixOS Wiki](https://wiki.nixos.org)
- [flake-parts](https://github.com/hercules-ci/flake-parts)
- [dendritic](https://github.com/mightyiam/dendritic)
- [dendritic-design-with-flake-parts](https://github.com/Doc-Steve/dendritic-design-with-flake-parts)
- [nixvim](https://github.com/nix-community/nixvim)
- [home-manager](https://github.com/nix-community/home-manager)
- [NixOS-WSL](https://github.com/nix-community/NixOS-WSL)
- [import-tree](https://github.com/vic/import-tree)
