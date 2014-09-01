#!/bin/sh
# Author: Marguerite Su <i@marguerite.su>
# Version: 1.0
# License: GPL-3.0
# Description: Download Bing Wallpaper of the Day and set it as your Linux Desktop.

# $bing is needed to form the fully qualified URL for
# the Bing pic of the day
bing="www.bing.com"

# The mkt parameter determines which Bing market you would like to
# obtain your images from.
# Valid values are: en-US, zh-CN, ja-JP, en-AU, en-UK, de-DE, en-NZ, en-CA.
mkt="en-US"

# The idx parameter determines where to start from. 0 is the current day,
# 1 the previous day, etc.
idx="0"

# $xmlURL is needed to get the xml data from which
# the relative URL for the Bing pic of the day is extracted
xmlURL="http://www.bing.com/HPImageArchive.aspx?format=xml&idx=$idx&n=1&mkt=$mkt"

# $saveDir is used to set the location where Bing pics of the day
# are stored.  $HOME holds the path of the current user's home directory
saveDir="$HOME/Pictures/wallpaper/"

# Create saveDir if it does not already exist
mkdir -p $saveDir

# Set picture options
# Valid options are: none,wallpaper,centered,scaled,stretched,zoom,spanned
picOpts="zoom"

# The file extension for the Bing pic
picExt=".jpg"

# Download the highest resolution
# while true; do

#    TOMORROW=$(date --date="tomorrow" +%Y-%m-%d)
#    TOMORROW=$(date --date="$TOMORROW 00:10:00" +%s)
    
    for picRes in _1920x1200 _1366x768 _1280x720 _1024x768; do
	#for picRes in _1366x768 _1280x720 _1024x768; do
		# Extract the relative URL of the Bing pic of the day from
		# the XML data retrieved from xmlURL, form the fully qualified
		# URL for the pic of the day, and store it in $picURL
		echo "Downloading $picRes resolution"
        echo $xmlURL
		picURL=$bing$(echo $(curl -s $xmlURL) | egrep -o "<urlBase>(.*)</urlBase>" | cut -d ">" -f 2 | cut -d "<" -f 1)$picRes$picExt

		echo $picURL
		# $picName contains the filename of the Bing pic of the day
		picName=${picURL#*2f}
    
        echo $saveDir${picName##*/}
		# Download the Bing pic of the day
		curl -s -o $saveDir${picName##*/} $picURL

		# Test if it's a pic
		#file $saveDir${picName##*/} | grep HTML && rm -rf $saveDir${picName##*/} && continue
		#break
		
		if [ $(file $saveDir${picName##*/} | grep HTML -c) -eq 1 ]
		then
			rm -rf $saveDir$picName
			echo "$picRes resolution not found"
			continue
		else
			echo "complete download of $picRes resolution"
			break
		fi
		
    done

    # detect the environment type
    # detectDE 

#    if [ $DESKTOP_SESSION = "cinnamon" ]; then
#		Set the GNOME3 wallpaper
#		DISPLAY=:0 GSETTINGS_BACKEND=dconf gsettings set org.gnome.desktop.background picture-uri '"file://'$saveDir${picName##*/}'"'

#		Set the GNOME 3 wallpaper picture options
#		DISPLAY=:0 GSETTINGS_BACKEND=dconf gsettings set org.gnome.desktop.background picture-options $picOpts
#    fi

#    if [ $DESKTOP_SESSION = "kde" ]; then
#		test -e /usr/bin/xdotool || sudo zypper --no-refresh install xdotool
#		test -e /usr/bin/gettext || sudo zypper --no-refresh install gettext-runtime
#		./kde4_set_wallpaper.sh $saveDir$picName
#    fi

# set wallpaper for mac
osascript -e "tell application \"System Events\" to set picture of every desktop to \"$saveDir${picName##*/}\""

# Exit the script
exit 0
