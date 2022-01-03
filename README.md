# Installation instruction (~180min)

## Erase and Reinstall macOS Monterey (~40min)

- Restart your Mac and Hold to power button to start the Recovery Mode
- When the Mac restart choose Options
- In the menu, click Erase this Mac
- When the Mac restart connect to the WIFI network
- Type you Apple ID and Password (Stored in 1Password)
- When the Mac is activated, choose `Reinstall macOS Monterey`
- Continue and Agree the licence
- Select the `Macintosh HD` drive
- Wait the process to complete (~1h)
- Choose your country and `Customize options` to choose English as the main language
- Select and connect to your WIFI network
- Don't use Migration Assistant by click `Not Now`
- Sign-in to your Apple account (Password still stored in 1Password), you need another macOS/iOS device for the activation code
- Accept term & conditions
- In `Create a Computer Account`, set the relevant values
- In `Make This Your New Mac`, deactivate `Siri` and use `Dark` appearance, click `Continue`
- Setup your `Touch ID`
- Skip Apple Pay by clicking `Set Up Later...`

## Install dotfiles repository

### Pre-configuration (~25min)

- Open Safari on login to Github (1Password + Google Authenticator)
- Create a [new Personal access token](https://github.com/settings/tokens) in Github to use HTTPS repositories
- Open the Terminal
- `git clone https://github.com/mazerte/dotfiles.git ~/.dotfiles`. **Use your Personal access token instead of your password as password**. We'll start with `https` but switch to `ssh` after everything is installed.
- `cd ~/.dotfiles`
- `./initialize`
- When is finish, login to 1Password using the OR Code generate by the mobile app (Settings > Accounts > User > Configure another device)
- Login to Dropbox (You may have to remove an account before, don't setup backup features). Wait the sync to complete.
- Open VeraCrypt and try to mount the secure volume stored in Dropbox folder:
  - `System Extension Blocked`, click `Open Security Preferences`, unlock and click `Enable system extensions` and then `Shut down`. **Hold the power button at startup to open the macOS Recovery app**
  - Select your user and type your user password
  - Click unlock for `Macintosh HD` drive. Re-use the same password
  - Click `Security Policy`, choose `Reduced Security` and click `Allow user management of kernel extensions from identified developers`
  - Click `Ok` and type your password. (~1min)
  - Restart the computer
  - Preferences Panel should be open on `Security & Privacy`, unlock and allow `Bengamin Fleischer`.
  - Type your password and restart
  - Finally try to mount the secure volume again

### Configure the whole system (~100min)

- `./install`, You will ask to type your user password a lot of time
- `id_github_rsa` password is stored in 1Password under `github.com` > `ssh`
- Login to Autodesk Fusion360 (password stored in 1Password)
- If `GPG Mail Monterey Activator` ask to Enable click `Not Now`
- When installation is finished, restart the computer
- Run `mackup restore` through `iTerm2` in `~/.dotfiles`. Consider doing a `mackup restore --dry-run --verbose` first.

### Manual installation (~5min)

- Atem MINI: (https://www.blackmagicdesign.com/support/family/atem-live-production-switchers and choose ATEM Switchers last version)

## Setup (~20min)

### Alfred

- Open `Alfred` and click `Begin Setup`
- Add the licence from 1Password
- Continue without migration
- On `macOS Persissions`, click all buttons and `Restart Alfred`
- In `Alfred` > Advanced `Set preferences folder` and choose the `dotfiles` folder in Dropbox. Restart Alfred

### Chrome

- Open `Chrome` and set it as default browser
- Login in
- Setup `Turn on Sync`

### Slack

Open `Slack` and add these accounts manually

- mazerte
- amzn-aws
- aircall
- datadome
- ybcdata
- huggingface

### Reeder

TODO

### Licenced or Log-on Software

- Aurora HDR
- Charles Proxy
- Docker
- DxO PureRaw
- Luminar AI
- Optix2
- Spotify
- Zoom

### Software to open

- Companion
- Display Link Manager
- Stats
- Giphy
- ScreenBrush
- Snappy

### Bartender

Open `Bartender` app and setup permissions

### Last steps

- Change screen resolution
- Change screen wallpaper

## Troubleshooting

If package installation is stuck either in `Installing` or `Waiting` state, you can exists the installation script and type these commands:

```
sudo rm /private/var/db/mds/system/mds.install.lock
sudo killall -1 installd
```
