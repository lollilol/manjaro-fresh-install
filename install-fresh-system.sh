#documentation: https://github.com/lollilol/manjaro-fresh-install/blob/master/README.md#setup
base_packages="chromium pinta teamspeak3 wine wine-mono wine_gecko grub-customizer figlet pavucontrol nemo nemo-fileroller nemo-image-converter xfce4-taskmanager xfce4-screenshooter ntp telegram-desktop filezilla grub-customizer winetricks alacarte mtools os-prober xdotool yay python3 flatpak"
uninstall_packages="memtest86+ gnome-screenshot lollypop"
theme_packages="arc-gtk-theme"
gtk_theme="Arc-Dark"
shell_theme="Arc-Dark"
icon_theme="Papirus-Dark-Maia"
aur_packages="spotify discord ttf-emojione ttf-google-sans ttf-opensans minecrafter-ttf jre winscp woeusb minecraft-launcher ttf-ms-fonts chromium-widevine"
timezone="Europe/Berlin"


read -p "Continue? Only do this, if you freshly installed manjaro! (y/N) " start

case "$start" in
y|Y)

clear
sleep 1
echo "This script installs packages and changes some configs."
echo "Well, then, lets start!"
echo
echo "1. Packages"
echo
echo "1.1: Full System Upgrade"
echo
sudo pacman -Syu
echo
echo "1.2: Installing Base Packages"
echo
sudo pacman --noconfirm --needed -S $base_packages

echo
echo "1.2.2: Uninstall unused Packages"
echo
sudo pacman --noconfirm -R $uninstall_packages $(pacman -Qtdq)
echo
echo "1.3: Themes"
echo
echo "1.3.1: Installing Themes"
echo
sudo pacman --noconfirm --needed -S $theme_packages
echo
echo "1.3.2: Activate/Change Themes"
gsettings set org.gnome.desktop.interface gtk-theme "$gtk_theme"
gsettings set org.gnome.shell.extensions.user-theme name "$shell_theme"
gsettings set org.gnome.desktop.interface icon-theme "$icon_theme"
echo
echo "1.4: Installing AUR Packages"
echo
yay --noconfirm --needed -S $aur_packages
echo
echo "2. Misc Configurations"
echo
echo "2.1: Disable Sound Effects in Gnome"
gsettings set org.gnome.desktop.sound event-sounds false
echo "2.2: Backup Original Pulseaudio Config and copy the one from the home dir"
sudo mv /etc/pulse/default.pa /etc/pulse/default.pa.orig
sudo cp ~/bin/install-fresh-system-c/pulseaudio-default.pa /etc/pulse/default.pa
echo "2.2.1: Restart Pulseaudio"
pulseaudio -k
sleep 2
pulseaudio --start
echo "2.3: Telegram Tray Autostart"
cp ~/bin/install-fresh-system-c/telegramdesktop_tray.desktop ~/.config/autostart/telegramdesktop_tray.desktop
echo "2.4: Various Time Configurations"
echo
sudo ln -sf /usr/share/zoneinfo/$timezone /etc/localtime
sudo ntpdate 0.pool.ntp.org
echo
echo "2.5 Init Razer Stuff"
sudo gpasswd -a lollilol plugdev
echo "2.5.1 Razer Blackwidow Init"
sudo cp ~/bin/install-fresh-system-c/razer/init_blackwidow.py /root/init_blackwidow.py
sudo cp ~/bin/install-fresh-system-c/razer/razer_blackwidow.rules /etc/udev/rules.d/razer_blackwidow.rules
sudo chmod a+x /root/init_blackwidow.py
#echo "2.5.2 Razer Deathadder Elite Init"
#echo
#echo "2.6 Installing 31_hold_shift"
#sudo cp ~/bin/install-fresh-system-c/31_hold_shift /etc/grub.d
#sudo chmod a+x /etc/grub.d/31_hold_shift
#sudo update-grub

echo "3. Notes"
echo
echo "Dont forget to install mutter-781835-workaround from AUR if you are nvidia user and have proprietary drivers installed." 
echo
echo "Done"

;;
*)

echo
echo Aborted!

;;
esac

sleep 1
echo Quitting now!
sleep 1
exit