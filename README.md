# Use dotfiles

```bash
git clone https://github.com/yezooz/dotfiles.git ~/.dotfiles
/bin/bash -c "~/.dotfiles/init/init.sh"
```

Launch `vim` and run `:PluginInstall`

## Dev tools

```bash
/bin/bash -c "~/.dotfiles/init/dev_tools.sh"
```

## Desktop tools

```bash
/bin/bash -c "~/.dotfiles/init/desktop_tools.sh"
```

## MacOS

### Extras

https://mwholt.blogspot.be/2012/09/fix-home-and-end-keys-on-mac-os-x.html

### iTerm

Install Powerline fonts for iTerm by following instructions on https://github.com/powerline/fonts

Themes https://github.com/mbadolato/iTerm2-Color-Schemes

## Ubuntu

```bash
sudo adduser $username
sudo usermod -aG sudo $username
```
