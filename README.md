## Steps to bootstrap a new Mac

1. Install Apple's Command Line Tools, which are prerequisites for Git and Homebrew.

```zsh
xcode-select --install
```

2. Install Homebrew, followed by the software listed in the Brewfile.

```zsh
# These could also be in an install script.

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Then pass in the Brewfile location...
brew bundle --file ~/.dotfiles/Brewfile

# ...or move to the directory first.
cd ~/.dotfiles && brew bundle
```

3. Use Stow to Manage Dotfiles

To apply your dotfiles (configuration files), use stow to symlink them from your `~/.dotfiles` directory to the appropriate locations in your home directory.

Run the following command to symlink all dotfiles:

```
stow ~/.dotfiles/* <folder name>
```

This will create symlinks for all the configuration files in your `~/.dotfiles` directory, ensuring that your system is set up with your desired configurations.
