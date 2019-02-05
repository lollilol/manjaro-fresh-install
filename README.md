# manjaro-fresh-install
basic bash script to install some packages and move config files

## Disclaimer
this is just my personal script to install some key packages in my system, if i installed it freshly.
You can edit it a little bit and use it then.
Theme Options are currently only supported when using gnome3.

## Download

#### Direct Link
> https://raw.githubusercontent.com/lollilol/manjaro-fresh-install/master/install-fresh-system

#### OneCommand

```
$ wget https://raw.githubusercontent.com/lollilol/manjaro-fresh-install/master/install-fresh-system && nano install-fresh-system && chmod +x install-fresh-system && ./install-fresh-system
```

## Setup
### Configuration

#### Just edit the script with your favorite text editor
**base_packages=**

The Packages supplied here wil get installed on your system with **pacman--noconfirm --needed -S**

**uninstall_packages=**

The Packages supplied here will get uninstalled just with **pacman -R**

**theme_packages=**

Every Package supplied here will just get installed like the base packages. Base packages and theme packages are just seperated for better understanding.

**gtk_theme=**

The Theme supplied here will be activated as GTK Theme in Gnome3.

**shell_theme=**

The Theme supplied here will be activated as Shell Theme in Gnome3.

**icon_theme=**

The Theme supplied here will be activated as Icon Theme in Gnome3.

**aur_packages=**

The Packages supplied here will be installed with **yay --noconfirm --needed -S"

**timeonze=**

The Timezone supplied here will be linked to /etc/localtime
Usage: `Europe/Berlin` / `America/New_York`
