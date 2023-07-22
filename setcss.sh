#!/bin/bash
#
# Applies a global CSS stylesheet to all Obsidian vaults.

#######################################
# Throws an error if invalid changes to `.obsidian/appearance.json`.
# Globals:
#   OBSIDIAN_HOME
#	vault
# Arguments:
#   None
# Outputs:
#   Writes error message to stderr.
#######################################
catch(){
	echo "ERROR: Proposed changes to '$OBSIDIAN_HOME/$vault/.obsidian/appearance.json' are invalid." >&2
	exit 1
}

vaults=$(ls $OBSIDIAN_HOME)
for vault in $vaults; do
	if ! [[ -d $OBSIDIAN_HOME/$vault/.obsidian/snippets ]]; then
		mkdir $OBSIDIAN_HOME/$vault/.obsidian/snippets
	fi

	echo "Applying global CSS stylesheet to vault '$OBSIDIAN_HOME/$vault'..."
	cp $OBSIDIAN_STYLESHEET $OBSIDIAN_HOME/$vault/.obsidian/snippets/stylesheet.css
	jq '.enabledCssSnippets += ["stylesheet"]' $OBSIDIAN_HOME/$vault/.obsidian/appearance.json > $OBSIDIAN_HOME/$vault/.obsidian/tmp.json
	trap "catch" ERR
	test -s $OBSIDIAN_HOME/$vault/.obsidian/tmp.json
	mv $OBSIDIAN_HOME/$vault/.obsidian/tmp.json $OBSIDIAN_HOME/$vault/.obsidian/appearance.json

	echo "Global CSS stylesheet successfully applied to vault '$OBSIDIAN_HOME/$vault'."
done
