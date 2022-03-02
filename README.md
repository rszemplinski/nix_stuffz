# nix stuffz

[![uses nix](https://img.shields.io/badge/uses-nix-%237EBAE4)](https://nixos.org/)

_my nixpkgs folder_

## install

```bash
# install nix
curl -L https://nixos.org/nix/install | sh

# configure nix to use more cpu/ram when building
mkdir -p ~/.config/nix/
echo 'max-jobs = auto' >>~/.config/nix/nix.conf

# Add nix channels
nix-channel --add https://nixos.org/channels/nixos-unstable nixpkgs
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install # if not on nixos?

# pull repo
cd ~
REPO_DIR="cfg"
git clone git@github.com:rszemplinski/nix_stuffz.git "$REPO_DIR"
rm -rf $HOME/.config/nixpkgs
ln -s $HOME/"$REPO_DIR"/nixpkgs $HOME/.config/nixpkgs

# move unneeded files
mv ~/.bash_history ~/.bash_history.old
mv ~/.bash_profile ~/.bash_profile.old
mv ~/.bashrc ~/.bashrc.old
mv ~/.zshrc ~/.zshrc.old
mv ~/.profile ~/.profile.old
mv ~/.gitconfig ~/.gitconfig.old

# enable home-manager and build packages
home-manager switch
```