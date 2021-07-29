# setup

## install nix and home manager
```
curl -L https://nixos.org/nix/install | sh
. /home/shoh/.nix-profile/etc/profile.d/nix.sh
nix-channel --add https://github.com/nix-community/home-manager/archive/release-21.05.tar.gz home-manager
nix-channel --update;
nix-shell '<home-manager>' -A install;
```

## generate
```
git clone https://github.com/SiewYan/nixfiles.git ~/Install/nixfiles
rm -rf ~/.config/nixpkgs
cd ~/.config/nixpkgs; rm -rf nixpkgs
ln -s ~/Installs/nixfiles/bashrc/nixpkgs/ nixpkgs
home-manager switch; reload
```
