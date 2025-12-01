sudo pacman -S fcitx5 fcitx5-configtool fcitx5-hangul
sudo rm /etc/xdg/autostart/org.fcitx.Fcitx5.desktop
sudoedit /etc/environment
# append the following:
# GTK_IM_MODULE=fcitx
# QT_IM_MODULE=fcitx
# XMODIFIERS=@im=fcitx

# select the proper input method under virtual keyboard (fcitx5)
# under input methods select add input method and then uncheck the box in the bottom left
# click hangul and ur done
