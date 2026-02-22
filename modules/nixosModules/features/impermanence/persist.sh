#!/usr/bin/env bash

###############################################################################
#
# persist.sh does a few things:
#   Well... right now, it does nothing. But the idea is to list the paths
#   opted in the persistence list and if they are not yet in /persist,
#   move them.
# 
# @todo Everything.
# 
###############################################################################

# If any error occurs, exit
# -------------------------
set -euo pipefail

ROOT_PART=/dev/mapper/cryptroot

# persist_root="/persist"
# eval_query="${DOTFILES}#nixosConfigurations.${HOST}.config"

# system_objects="$(nix eval --json ${eval_query}.environment.persistence)"
# # home_objects="$(nix eval --json ${eval_query}.home-manager.users.unnamedplayer.home.persistence)"


# system_directories=$(echo $system_objects | jq -c '.[].directories')
# system_files=$(echo $system_objects | jq -c '.[].files')

# while read persist
# do
#   sourcePath=$(echo "$persist" | jq -r '.dirPath')
#   persistentStoragePath=$(echo "$persist" | jq -r .persistentStoragePath)

#   cp -R ${sourcePath}/. ${persistentStoragePath}${sourcePath}/
# done < <(echo "$system_directories" | jq -c '.[]')

# while read persist
# do
#   sourcePath=$(echo "$persist" | jq -r '.filePath')
#   persistentStoragePath=$(echo "$persist" | jq -r .persistentStoragePath)

#   cp ${sourcePath} ${persistentStoragePath}${sourcePath}
# done < <(echo "$system_files" | jq -c '.[]')


# echo "That's all, folks!" && exit
