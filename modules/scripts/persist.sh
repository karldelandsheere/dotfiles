#!/usr/bin/env bash
# --------------------------------------------------------------

# If any error occurs, exit
# -------------------------
set -euo pipefail


dotfiles=/etc/nixos
hostname="q3dm10" # @todo Make it less hardcoded
persist_root="/persist"
eval_query="${dotfiles}#nixosConfigurations.${hostname}.config"

system_objects="$(nix eval --json ${eval_query}.environment.persistence)"
# home_objects="$(nix eval --json ${eval_query}.home-manager.users.unnamedplayer.home.persistence)"


system_directories=$(echo $system_objects | jq -c '.[].directories')
system_files=$(echo $system_objects | jq -c '.[].files')

while read persist
do
  sourcePath=$(echo "$persist" | jq -r '.dirPath')
  persistentStoragePath=$(echo "$persist" | jq -r .persistentStoragePath)

  cp -R ${sourcePath}/. ${persistentStoragePath}${sourcePath}/
done < <(echo "$system_directories" | jq -c '.[]')

while read persist
do
  sourcePath=$(echo "$persist" | jq -r '.filePath')
  persistentStoragePath=$(echo "$persist" | jq -r .persistentStoragePath)

  cp ${sourcePath} ${persistentStoragePath}${sourcePath}
done < <(echo "$system_files" | jq -c '.[]')


echo "That's all, folks!" && exit
