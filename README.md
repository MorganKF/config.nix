# config.nix

# Setup
Clone flake
```bash
nix flake clone github:MorganKF/config.nix --dest ~/config.nix --extra-experimental-features "nix-command flakes"
```
## Darwin
Install homebrew
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Run darwin rebuild
```bash
nix run nix-darwin/master#darwin-rebuild --extra-experimental-features "nix-command flakes" -- switch --flake ~/Documents/config.nix
```

Increase maximum semiphores if building fails
```bash
sudo sysctl -w kern.posix.sem.max=40000
```
