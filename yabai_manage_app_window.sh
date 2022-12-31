#!/bin/sh

file=~/.yabairc
trunc_bottom="$(grep -n "" $file | sort -nr | sed '1,2d' | sort -n | sed 's/^[0-9]*://')"
app=$(yabai -m query --windows --window | jq -re '.app')
title=$(yabai -m query --windows --window | jq -re '.title')
generated_app_rule="yabai -m rule --add app=\"\^$app\\\$\" manage=off"
generated_title_rule="yabai -m rule --add app=\"\^$(yabai -m query --windows --window | jq -re '.app')\\\$\" title=\"^$(yabai -m query --windows --window | jq -re '.title')\\\$\" manage=off"
generated_title_rule_regex="yabai -m rule --add app=\"^$(yabai -m query --windows --window | jq -re '.app')\\\$\" title=\"\^\.\*\?$(yabai -m query --windows --window | jq -re '.title')\.\*\?\\\$\" manage=off"

echo "$trunc_bottom"
#echo "$generated_app_rule"
#echo "$generated_title_rule"
#echo "$generated_title_rule_regex"

# Does the rule already exist?
egrep -q -- "$generated_app_rule|$generated_title_rule" $file
if [ $? -eq 0 ]; then
	echo "Removing the existing rule."
	egrep -v -- "$generated_app_rule|$generated_title_rule" $file > $file
else
	echo "Adding the new rule."
	echo "$trunc_bottom" > $file
	echo "$generated_title_rule" >> $file
	echo "" >> $file
	echo "echo \"yabai configuration loaded...\"" >> $file
fi

