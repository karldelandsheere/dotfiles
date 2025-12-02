#!/usr/bin/env bash
#
# Startup script to launch the TUI apps I always use
# --------------------------------------------------

# The apps I want to launch
apps=( "aerc" "calcurse" "gurk" "iamb" )

# Launch each in the background
for app in "${apps[@]}"; do
  eval "ghostty --title=\"$app\" -e $app" &
done

# Give some time for everything to settle
sleep 2

# Order the windows in columns
niri msg action focus-column-left && # From column 4 to column 3
niri msg action consume-window-into-column && # Merge columns 3 and 4
niri msg action focus-column-left && # From column 3 to 2
niri msg action focus-column-left && # From column 2 to 1
niri msg action consume-window-into-column && # Merge columns 1 and 2
niri msg action focus-column-left # Recenter by focussing on column 1





# Launch all two Ghostty windows in the background
# with aerc and calcurse
# then merge them in one column
# ghostty --title="aerc" -e aerc &
# ghostty --title="calcurse" -e calcurse &
# sleep 1
# niri msg action focus-column-left &&
# niri msg action consume-window-into-column

# Launch all two Ghostty windows in the background
# with gurk and iamb
# then merge them in one column
# ghostty --title="gurk" -e gurk &
# ghostty --title="iamb" -e iamb &
# sleep 1
# niri msg action focus-column-left &&
# niri msg action consume-window-into-column

# Recenter the workspace
# niri msg action focus-column-left
