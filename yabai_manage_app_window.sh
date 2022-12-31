#!/bin/sh

toggle_app=$1
file=$(readlink -f ~/.yabairc)
trunc_bottom="$(grep -n "" $file | sort -nr | sed '1,2d' | sort -n | sed 's/^[0-9]*://')"
app=$(yabai -m query --windows --window | jq -re '.app')
title=$(yabai -m query --windows --window | jq -re '.title')

# Does the rule already exist?
if [ -n "$toggle_app" ]; then
	egrep -q -- "label=\"$app(\|$title)?\"" $file
	if [ $? -eq 0 ]; then
		echo "Removing the existing rule."

		sed "/label=\"$app\(\|$title\)*\"/d" $file > $file.new
		mv $file.new $file

		yabai -m rule --add app="^$app$" manage=on label="$app"
		yabai -m rule --remove "$app"
	else
		echo "Adding the new rule."

		echo "$trunc_bottom" > $file
		echo "yabai -m rule --add app=\"^$app\$\" manage=off label=\"$app\"" >> $file
		echo "" >> $file
		echo "echo \"yabai configuration loaded...\"" >> $file

		yabai -m rule --add app="^$app$" manage=off label="$app"
	fi
else
	egrep -q -- "label=\"$app(\|$title)?\"" $file
	if [ $? -eq 0 ]; then
		echo "Removing the existing rule."

		sed "/label=\"$app\(\|$title\)*\"/d" $file > $file.new
		mv $file.new $file

		yabai -m rule --add app="^$app$" title="^$title$" manage=on label="$app|$title"
		yabai -m rule --remove "$app|$title"
	else
		echo "Adding the new rule."

		echo "$trunc_bottom" > $file
		echo "yabai -m rule --add app=\"^$app\$\" title=\"^$title\$\" manage=off label=\"$app|$title\"" >> $file
		echo "" >> $file
		echo "echo \"yabai configuration loaded...\"" >> $file

		yabai -m rule --add app="^$app$" title="^$title$" manage=off label="$app|$title"
	fi
fi

