export TERMINFO=$HOME/.config/terminfo
export CLICOLOR=1

home-upgrade () {
  nix flake update $HOME/Repositories/nix/nix-dotfiles/home-manager
  home-manager switch --flake "/Users/michael/Repositories/nix/nix-dotfiles/home-manager#macbook-pro"
}

home-switch () {
  home-manager switch --flake "/Users/michael/Repositories/nix/nix-dotfiles/home-manager#macbook-pro"
}

system-upgrade () {
   nix flake update $HOME/Repositories/nix/nix-dotfiles/darwin
   darwin-rebuild switch --flake "$HOME/Repositories/nix/nix-dotfiles/darwin#MacBook-Pro"
}

system-switch () {
   darwin-rebuild switch --flake "$HOME/Repositories/nix/nix-dotfiles/darwin#MacBook-Pro"
}