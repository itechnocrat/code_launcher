#! /usr/bin/bash

BASE="$HOME"
CODE_WORK_DIR="$BASE/code-insiders-data"
CODE_WORK_DATA_DIR="$CODE_WORK_DIR/common"
CODE_WORK_EXTENSIONS_DIR="$CODE_WORK_DIR/extensions"
CODE_BIN_FILE="/opt/visual-studio-code-insiders/bin/code-insiders"

#PROFILE="Default"
WORKSPACE="."
DEBUG="debug"

function get_length_array {
  local -n array=$1
  echo ${#array[*]}
}

function array_dump {
  local -n array=$1
  echo "${array[*]}"
}

function print_array {
  local -n array=$1
  for item in "${array[@]}"; do
    printf "%s\n" "$item"
  done
}

function log {
  declare -g DEBUG
  if [[ ! -v DEBUG ]]; then
    exit 0
  fi
  local -n array=$1
  # call get_length_array
  # call array_dump
  echo
}

function merge_arrays {
  local -n array_a=$1
  local -n array_b=$2
  local -n acc=$3
  for element in "${array_a[@]}"; do
    acc+=("$element")
  done
  for element in "${array_b[@]}"; do
    acc+=("$element")
  done
  return 0
}

# Check the existence of a profile.
# Usage:
# just call profile_exists
# Globals:
#   combos - associated array
#   LANGUAGE - profile name
# Returns:
#   0 - profile configuration exists
#   1 - profile configuration not exists
function profile_exists {
  for key in "${!combos[@]}"; do
    if [[ "$key" == "$LANGUAGE" ]]; then
      return 0
    fi
  done
  return 1
}

# Check the existence of a language combo sets.
# Usage:
# check_key_array associated_array language_id
# Arguments:
#   associated_array - combo sets
#   language_id - key of associated array
# Returns:
#   exit_code - yes or no language_id
function check_key_array {
  local -n input_array=$1
  local input_key=$2
  local -i exit_code=1
  local local_key
  for local_key in "${!input_array[@]}"; do
    if [[ "$local_key" == "$input_key" ]]; then
      exit_code=0
    fi
  done
  return $exit_code
}

function code_launcher {
  local -n arg=$1
  $CODE_BIN_FILE \
    --profile "$PROFILE" \
    --user-data-dir "$CODE_WORK_DATA_DIR" \
    --extensions-dir "$CODE_WORK_EXTENSIONS_DIR" \
    "${arg[@]}"
  return $?
}

# function get_installed_extensions {
# $CODE_BIN_FILE \
# --profile "$LANGUAGE" \
# --user-data-dir $CODE_WORK_DATA_DIR \
# --extensions-dir $CODE_WORK_EXTENSIONS_DIR \
# --list-extensions \
# "$WORKSPACE"
# return $?
# }
function get_installed_extensions {
  local -a launch_arguments
  launch_arguments+=("--list-extensions")
  code_launcher launch_arguments
  return $?
}

function get_list_installed_extensions {
  local -n result=$1
  # https://www.shellcheck.net/wiki/SC2207
  mapfile -t result < <((get_installed_extensions) | tr ' ' '\n' | sort)
  return $?
}

function trick {
  local -n array=$1
  local -a acc
  for element in "${array[@]}"; do
    acc+=("$element")
  done
  echo "${acc[*]}"
}

function get_exts {
  local -n bottom_result=$1
  local -n bottom_set=$2
  for ext in "${bottom_set[@]}"; do
    bottom_result+=("$ext")
    # echo "$ext"
  done
}

function get_sets {
  local -n middle_result=$1
  local -n middle_combo=$2
  local -n middle_set
  for middle_set in "${middle_combo[@]}"; do
    echo "${middle_set[@]}" 1 >&/dev/null
    get_exts middle_result middle_set
  done
}

function get_total_list_extensions {
  local -n top_result=$1
  # local -g combos
  local -n combo_name
  local -a intermediate
  # local ext=""
  # local key
  for combo_name in "${combos[@]}"; do
    echo "${combo_name[@]}" 1 >&/dev/null
    get_sets intermediate combo_name
  done
  # mapfile -O 0 top_result < <(trick top_result | tr ' ' '\n' | sort | uniq -u | tr '\n' ' ')
  # mapfile -t -O 0 top_result < <((trick intermediate) | tr ' ' '\n' | sort | uniq)
  mapfile -t top_result < <((print_array intermediate) | sort | uniq)
  # echo ${#top_result[*]}
  # echo "${top_result[@]}"
  # print_list top_result
  # if [[ ${#top_result[*]} == 0 ]]; then
  #   exit 1
  # fi
  return 0
}

# Combines combinations of sets into one array.
# Usage:
# function arg result
# Arguments:
#   arg - array of arrays
#   result - merged arrays
# Outputs:
#   result - merged arrays
# Returns:
#   0
function get_list_extensions_for_ {
  local _key=$1
  local -n _result=$2
  local -n _combo_name
  local -a intermediate
  # echo "${combos[$_key]}"
  _combo_name="${combos[$_key]}"
  # echo "${_combo_name[*]}"
  get_sets intermediate _combo_name
  # echo "${intermediate[*]}"
  # mapfile -t -O 0 _result < <((trick intermediate) | tr ' ' '\n' | sort | uniq)
  mapfile -t -O 0 _result < <((print_array intermediate) | sort | uniq)
  return 0
}

# Calculate the difference between two lists.
# Usage:
# function list_1 list_2 difference
# list_1 - list_2 = difference (for install)
# list_2 - list_1 = difference (for remove)
# Arguments:
#   list_1 (demand)
#   list_2 (installed)
#   difference
# Outputs:
#   difference
# Returns:
#   0
function difference_of_list {
  local -n ref_to_list_1=$1
  local -n ref_to_list_2=$2
  local -n ref_to_differences_lists=$3
  local match_flag="no"
  # take the element of the first list
  for element_of_list_1 in "${ref_to_list_1[@]}"; do
    # compare with each element of the second list
    for element_of_list_2 in "${ref_to_list_2[@]}"; do
      if [[ "$element_of_list_1" == "$element_of_list_2" ]]; then
        # echo "$element_of_list_1 = $element_of_list_2"
        match_flag="yes" # fix a match - the element is present in both lists
        break            # finish iterating the second list
      fi
    done
    # if an element from the first list does not match any element from the second list
    if [[ "${match_flag}" == "no" ]]; then
      # add this item to difference list
      ref_to_differences_lists+=("$element_of_list_1")
      # echo "$element_of_list_1"
    fi
    match_flag="no" # reset match flag
  done              # move to the next item from the first list
  return 0
}

# Description
# Usage:
# function_name array_extensions_for_uninstall
# Arguments:
#   array_extensions_for_uninstall
# Outputs:
#
# Returns:
#
function uninstall_extensions {
  local -n array_extensions=$1
  local -a launch_arguments
  for ext in "${array_extensions[@]}"; do
    launch_arguments+=("--uninstall-extension")
    launch_arguments+=("$ext")
  done
  code_launcher launch_arguments
  return $?
}

function update_extensions {
  local -a launch_arguments
  launch_arguments+=("--update-extensions")
  code_launcher launch_arguments
  return $?
}

function install_extensions {
  local -n array_extensions=$1
  local -a launch_arguments
  for ext in "${array_extensions[@]}"; do
    launch_arguments+=("--install-extension")
    launch_arguments+=("$ext")
    launch_arguments+=("--pre-release")
  done
  code_launcher launch_arguments
  return $?
}

run_editor_with_extensions_disabled() {
  local -n array_extensions=$1
  local -a launch_arguments
  for ext in "${array_extensions[@]}"; do
    launch_arguments+=("--disable-extension")
    launch_arguments+=("$ext")
  done
  launch_arguments+=("--new-window")
  launch_arguments+=("$WORKSPACE")
  code_launcher launch_arguments
  return $?
}
