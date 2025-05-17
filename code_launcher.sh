#! /usr/bin/bash

# TODO: use argbash - https://argbash.dev/

# Usage this script:
# code lang profile
# where language_id is a programming language or a stack and etc.
# Without specifying profile, the script runs with common set extensions only.

set -e
# set -x

# https://wiki.archlinux.org/title/Visual_Studio_Code#Unable_to_move_items_to_trash
#export ELECTRON_TRASH=trash-cli

LAUNCHER_DIR="$HOME/.local/share/code_launcher"
# shellcheck source=/dev/null
source "${LAUNCHER_DIR}/code_launcher_db"
# shellcheck source=/dev/null
source "${LAUNCHER_DIR}/code_launcher_api"

# checking script arguments
# if [[ $# -gt 1 ]]; then
# echo "For now, one argument is enough."
# exit 1
# fi

# if [[ "$1" = "" ]]; then
if [[ $# -eq 0 ]]; then
  # echo -n "Warning: VSCode will run with the Default profile!"
  echo -n "Warning: VSCode will run with the common set extensions!"
  echo
  LANGUAGE="common"
else
  LANGUAGE="$1"
fi

if [ "$1" = "help" ]; then
  declare -la options=("--help")
  code_launcher options
  exit 0
fi

# PROFILE="$2"
# OPTIONS="$3"

# If the combination not exists
# if ! profile_exists; then
# echo "Ooops! '${LANGUAGE}' configuration does not exist!"
# exit 1
# fi

# If the combination not exists
if ! check_key_array combos "$LANGUAGE"; then
  echo "Ooops! '$LANGUAGE' configuration does not exist!"
  exit 1
fi

# TODO: made update only for language exts
# TODO: show all available setups of launguage
# TODO: move this block to the launch area of the JS profile
# export NODE_ENV=production
# export BABEL_ENV=production
# export NODE_ENV=development
# export BABEL_ENV=development
# export ESLINT_NO_DEV_ERRORS=true
# export DISABLE_ESLINT_PLUGIN=true

# Stuff: Necessary, unnecessary

# function make_install_and_uninstall_lists {
# local -n required_extensions=$1
# local -n installed_extensions=$2
# local -n list_install=$3
# local -n list_uninstall=$4
# local -n install_size=$5
# local -n uninstall_size=$6
#
# difference_of_list required_extensions installed_extensions list_install
# difference_of_list installed_extensions required_extensions list_uninstall
# install_size=${#list_install[@]}
# uninstall_size=${#list_uninstall[@]}
# }

# Synchronization between the extension database and installed extensions
declare -la list_installed_exts
get_list_installed_extensions list_installed_exts
echo "List of already installed ext's: $(get_length_array list_installed_exts)"
array_dump list_installed_exts

declare -la total_list_exts
get_total_list_extensions total_list_exts
echo "Total list ext's: $(get_length_array total_list_exts)"
array_dump total_list_exts

declare -la list_exts_for_uninstall
difference_of_list list_installed_exts total_list_exts list_exts_for_uninstall
lenght_list_exts_for_uninstall=$(get_length_array list_exts_for_uninstall)
echo "List ext's for uninstall: $lenght_list_exts_for_uninstall"

# 1. Remove unnecessary extensions:
if [[ $lenght_list_exts_for_uninstall -gt 0 ]]; then
  array_dump list_exts_for_uninstall
  uninstall_extensions list_exts_for_uninstall
fi

# Update installed extensions
update_extensions

# 2. Install missing extensions
declare -la list_exts_for_install
difference_of_list total_list_exts list_installed_exts list_exts_for_install
lenght_list_exts_for_install=$(get_length_array list_exts_for_install)
echo "List ext's for install: $lenght_list_exts_for_install"
if [[ $lenght_list_exts_for_install -gt 0 ]]; then
  array_dump list_exts_for_install
  install_extensions list_exts_for_install
fi

# 4. Launch the editor with unnecessary extensions disabled
declare -la list_exts_for_language
get_list_extensions_for_ "$LANGUAGE" list_exts_for_language
echo "List of ext's for $LANGUAGE: $(get_length_array list_exts_for_language)"
array_dump list_exts_for_language

common_combo="common"
declare -la list_common_exts
get_list_extensions_for_ "$common_combo" list_common_exts
echo "List common ext's: $(get_length_array list_common_exts)"
array_dump list_common_exts

declare -la language_and_common_exts
merge_arrays list_exts_for_language list_common_exts language_and_common_exts
echo "Language and common ext's: $(get_length_array language_and_common_exts)"
array_dump language_and_common_exts

declare -la list_installed_exts
get_list_installed_extensions list_installed_exts
# Get list extensions that are not needed for a specific language:
declare -la list_exts_for_disable
difference_of_list list_installed_exts language_and_common_exts \
  list_exts_for_disable
# difference_of_list total_list_exts language_and_common_exts list_exts_for_disable
echo "List ext's for disable: $(get_length_array list_exts_for_disable)"
array_dump list_exts_for_disable
run_editor_with_extensions_disabled list_exts_for_disable

exit
