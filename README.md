# dotfiles

I ***learned*** about dotfiles at [dotfiles.eieio.xyz](http://dotfiles.eieio.xyz), and so can you!

## Restore Instructions

1. `xcode-select --install` (Command Line Tools are required for Git and Homebrew)
2. `git clone https://github.com/eieioxyz/dotfiles_macos.git ~/.dotfiles`. We'll start with `https` but switch to `ssh` after everything is installed.
3. `cd ~/.dotfiles`
4. If necessary, `git checkout <another_branch>`.
6. [`./install`](install)
7. Restart computer.
8. Setup up Dropbox (use multifactor authentication!) and allow files to sync before setting up dependent applications. Alfred settings are stored here. Mackup depends on this as well (and thus so do Terminal and VS Code).
9. Run `mackup restore`. Consider doing a `mackup restore --dry-run --verbose` first.

### Manual Steps



