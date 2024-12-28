#! /bin/bash
yad --text-info \
    --title=Date \
    --filename=<(echo -n $(date +%y/%m/%d) ) \
    --timeout=3 \
    --width=1 \
    --height=1 \
    --window-icon=/usr/share/icons/gnome/24x24/mimetypes/gnome-mime-text-x-vcalendar.png
