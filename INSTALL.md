# Installation instruction

## Erase and Reinstall macOS Monterey

* Restart your Mac and Hold to power button to start the Recovery Mode
* When the Mac restart choose Options
* In the menu, click Erase this Mac
* When the Mac restart connect to the WIFI network
* Type you Apple ID and Password (Stored in 1Password)
* When the Mac is activated, choose `Reinstall macOS Monterey`
* Continue and Agree the licence
* Select the `Macintosh HD` drive
* Wait the process to complete (~1h)
* Choose your country and `Customize options` to choose English as the main language
* Select and connect to your WIFI network
* Don't use Migration Assistant by click `Not Now`
* Sign-in to your Apple account (Password still stored in 1Password), you need another macOS/iOS device for the activation code
* Accept term & conditions
* In `Create a Computer Account`, set the relevant values
* In `Make This Your New Mac`, deactivate `Siri` and use `Dark` appearance, click `Continue`
* Setup your `Touch ID`
* Skip Apple Pay by clicking `Set Up Later...`

## Install dotfiles repository

### Pre-configuration

* Open Safari on login to Github (1Password + Google Authenticator)
* Create a [new Personal access token](https://github.com/settings/tokens) in Github to use HTTPS repositories
* Open the Terminal
* `git clone https://github.com/mazerte/dotfiles.git ~/.dotfiles`. **Use your Personal access token instead of your password as password**. We'll start with `https` but switch to `ssh` after everything is installed.
* `cd ~/.dotfiles`
* `./initialize`
* When is finish, login to 1Password using the OR Code generate by the mobile app (Settings > Accounts > User > Configure another device)
* Login to Dropbox (You may have to remove an account before, don't setup backup features). Wait the sync to complete.
* Open VeraCrypt and mount the secure volume stored in Dropbox folder:
  * `System Extension Blocked`, click `Open Security Preferences`, unlock and click `Enable system extensions` and then `Shut down`

### Configure the whole system

* `./install` (maybe run it twice ???), You will ask to type your user password a lot of time
* If `GPG Mail Monterey Activator` ask to Enable click `Not Now`

## Troubleshooting

If package installation is stuck either in `Installing` or `Waiting` state, you can exists the installation script and type these commands:

```
sudo rm /private/var/db/mds/system/mds.install.lock
sudo killall -1 installd
```

## Notes

`./install` fail because:

* `brew` wasn't on the `PATH`
* `mazerte/homebrew-software` use `ssh` and `VeraCrypt` isn't installed yet
* `tunnelblickctl` also fail (probably due to github ssh)
* `displaylink failled` because Rosetta2 must be installed
* Remove `iMovie`, `Garage Band`, `Pages`, `Keynote` and `Numbers` from Brewfile
* `autodesk-fusion360` install due to bad CPU type ???

## Ideas

Maybe install first `VeraCrypt`, `Dropbox` and `1Password` manually or through a specific script before the install. This script could also install Homebrew and setup the `PATH`. Also Install Rosetta2
