#! /usr/bin/bash

#
# license ...
#

# Run VSCode
# Usage:
# code_launcher profile_name options
# Arguments:
# profile_name - string
# options - array
# Outputs:
# Returns:
function code_launcher {
  local -n opt=$2
  $CODE_BIN_FILE \
    --profile "$1" \
    --user-data-dir "$CODE_WORK_DATA_DIR" \
    --extensions-dir "$CODE_WORK_EXTENSIONS_DIR" \
    "${opt[@]}"
  return $?
}

function request_installed_extensions {
  local -a options
  options+=("--list-extensions")
  code_launcher "$1" options
  return $?
}

# Creates a list of all installed ext's
# Usage:
# get_list_all_installed_exts language array
# Arguments:
# language - as key of combos
# array - array
# Outputs:
# list of all installed ext's
# Returns:
function get_list_all_installed_exts {
  local -n list_installed=$2
  # https://www.shellcheck.net/wiki/SC2207
  # mapfile -t list_installed < <( (request_installed_extensions "$1") | tr ' ' '\n' | sort)
  mapfile -t list_installed < <( (request_installed_extensions "$1") | tr ' ' '\n')
  return
}

#function trick {
#  local -n array=$1
#  local -a acc
#  for element in "${array[@]}"; do
#    acc+=("$element")
#  done
#  echo "${acc[*]}"
#}

function print_array {
  local -n array=$1
  for item in "${array[@]}"; do
    printf "%s\n" "$item"
  done
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
function get_list_exts_for {
  local -g combos
  local -n combo
  local -n resultat=$2
  local -a intermediate
  combo="${combos[$1]}"
  get_sets intermediate combo
  #mapfile -t resultat < <( (print_array intermediate) | sort | uniq)
  mapfile -t resultat < <( (print_array intermediate) | sort)
  return 0
}

#function get_list_extensions_for_ {
#  local _key=$1
#  local -n _result=$2
#  local -n _combo_name
#  local -a intermediate
#  # echo "${combos[$_key]}"
#  _combo_name="${combos[$_key]}"
#  # echo "${_combo_name[*]}"
#  get_sets intermediate _combo_name
#  # echo "${intermediate[*]}"
#  # mapfile -t -O 0 _result < <((trick intermediate) | tr ' ' '\n' | sort | uniq)
#  mapfile -t -O 0 _result < <( (print_array intermediate) | sort | uniq)
#  return 0
#}

# Calculate the difference between two lists.
# Usage:
# function list_1 list_2 difference
# list_1 - list_2 = difference (for install)
# list_2 - list_1 = difference (for remove)
# Arguments:
#   list_1 (demand)
#   list_2 (installed)
# Outputs:
#   difference
# Returns:
# TODO: rename func to difference_between_arrays
function diff_lists {
  local -n ref_to_list_1=$1
  local -n ref_to_list_2=$2
  local -n ref_to_differences_lists=$3
  local match_flag="no"
  # take the element of the first list
  for element_of_list_1 in "${ref_to_list_1[@]}"; do
    # compare with each element of the second list
    for element_of_list_2 in "${ref_to_list_2[@]}"; do
      if [[ "$element_of_list_1" == "$element_of_list_2" ]]; then
        #echo "$element_of_list_1 = $element_of_list_2"
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
  return 
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
  local -n list_extensions=$2
  local -a uninstall_options
  local -a reverse_list_extensions
  mapfile -t reverse_list_extensions < <( (print_array list_extensions) | sort -r)
  for ext in "${reverse_list_extensions[@]}"; do
    uninstall_options+=("--uninstall-extension")
    uninstall_options+=("$ext")
  code_launcher "$1" uninstall_options
  uninstall_options=()
done
  #array_dump reverse_list_extensions
  #echo "opt:"
  #array_dump uninstall_options
  #code_launcher "$1" uninstall_options
  return 
}

function update_extensions {
  local -a launch_arguments
  launch_arguments+=("--update-extensions")
  code_launcher "$1" launch_arguments
  return
}

function install_extensions {
  local -n array_extensions=$2
  local -a install_options=()
  local -i counter=1
  local ext
  for ext in "${array_extensions[@]}"; do
    echo "$counter"
    install_options+=("--install-extension")
    install_options+=("$ext")
    install_options+=("--pre-release")
    install_options+=("--force")
    echo "${install_options[@]}"
    code_launcher "$1" install_options
    #sleep 5 
    install_options=()
    counter+=1
  done
  #code_launcher "$1" install_options
  return
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
  return
}

function get_length_array {
  local -n array=$1
  echo ${#array[*]}
}

function array_dump {
  local -g DEBUG
    if [[ -v DEBUG ]]; then
      local -n array=$1
      echo ""
      echo "${array[*]}"
      echo ""
    fi
}

#function log {
#  locale -g DEBUG
#  if [[ -v DEBUG ]]; then
#  local -n array=$1
#  echo
#  # call and echo get_length_array
#  # call and echo array_dump
#  echo
#  fi
#}

function merge_arrays {
  local -n array_1=$1
  local -n array_2=$2
  local -n array_3=$3
  local -a acc
  for element in "${array_1[@]}"; do
    acc+=("$element")
  done
  for element in "${array_2[@]}"; do
    acc+=("$element")
  done
  mapfile -t array_3 < <( (print_array acc) | sort | uniq)
  return 
}

 # Check existence of key in associated array combos
 # Usage:
 # no_exists key
 # Arguments:
 #   associated_array - combo sets
 #   key - as language_id
 # Returns:
 #   exit_code - yes or no language_id
 function no_exists {
   local -g combos  
   local check_key=$1
   local -i return_code=0
   #local key
   for key in "${!combos[@]}"; do
     if [[ "$check_key" == "$key" ]]; then
       return_code=1
     fi
   done
   return $return_code
 }

# all existing ext's
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
  mapfile -t top_result < <( (print_array intermediate) | sort | uniq)
  # echo ${#top_result[*]}
  # echo "${top_result[@]}"
  # print_list top_result
  # if [[ ${#top_result[*]} == 0 ]]; then
  #   exit 1
  # fi
  return 0
}

return 
