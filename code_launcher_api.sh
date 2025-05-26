#! /usr/bin/bash

#
# license ...
#

# Run VSCode
# Usage:
# code_launcher workspace profile options
# Arguments:
# workspace @ string
# profile   @ string
# options   @ array
# Outputs: -
# Returns: -
code_launcher() {
  #local DIR=$1
  #local PROFILE=$2
  local -n opts=$3
  $CODE_BIN_FILE \
    "$1" \
    --profile "$2" \
    --user-data-dir "$CODE_WORK_DATA_DIR" \
    --extensions-dir "$CODE_WORK_EXTENSIONS_DIR" \
    "${opts[@]}"
  return
}

# Wrapper for code_launcher
# Helper for get_list_all_installed_exts
# Usage:
# code_launcher workspace profile
# Arguments:
# workspace @ string
# profile   @ string
# Outputs:  -
# Returns: List of installed extensions
#request_installed_extensions() {
#  local -a options
#  options+=("--list-extensions")
#  code_launcher "$1" "$2" options
#  return
#}

# Wrapper for request_installed_extensions
# Prepares a request and accepts the result.
# Usage:
# get_list_all_installed_ext profile array
# Arguments:
# profile   @ string
# Outputs:  @ array
# Returns:  Array of all installed extensions 
get_list_exts_installed() {
  local -n list_installed=$2
  local -la options
  #local -n acc
  options=("--list-extensions")
  # https://www.shellcheck.net/wiki/SC2207
  #mapfile -t list_installed < <( (request_installed_extensions "$1" "$2") | tr ' ' '\n')
  mapfile -t list_installed < <( (code_launcher "" "$1" options) | tr ' ' '\n' | sort)
  #mapfile -t list_installed < <( (print_array acc) | sort)
  return $?
}

# Expands two-dimensional array into one.
# Usage:
# expand_2-dimensional_array arg result
# Arguments:
#   arg @ array of arrays
# Outputs:
#   result @ arrays
# Returns:
#  All elements from all arrays 
expand_2-dimensional_array() {
  local -n outer_arrays=$1
  local -n new_array=$2
  local -n nested_array
  local element_nested_array
  for nested_array in "${outer_arrays[@]}"; do
    # echo "$nested_array"
    for element_nested_array in "${nested_array[@]}"; do
      # echo "$element_nested_array"
      new_array+=("$element_nested_array")
    done
  done
  return 
}

print_array() {
  local -n array=$1
  for item in "${array[@]}"; do
    printf "%s\n" "$item"
  done
}

# Wrapper for get_sets
# Prepares a request and accepts the result
# Usage:
# get_list_exts_fo key array
# Arguments:
# key       @ string Language name as key of combos array
# array     @ ref to array of all required extensions
# Outputs:  @ array
# Returns:  Array of required extensions
# TODO: remove global variable, argument instead
get_list_exts_for() {
  local -g combos
  local key="$1"
  local -n combo
  local -n resultat=$2
  local -a acc
  combo="${combos[$key]}"
  expand_2-dimensional_array combo acc 
  #get_sets acc combo
  mapfile -t resultat < <( (print_array acc) | sort | uniq)
  #mapfile -t resultat < <( (print_array acc) | sort)
  return 0
}

merge_arrays() {
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

install_extensions() {
  local -n array_extensions=$2
  local -a install_options=()
  #local -i counter=1
  local ext
  for ext in "${array_extensions[@]}"; do
    #echo "$counter"
    install_options+=("--install-extension")
    install_options+=("$ext")
    install_options+=("--pre-release")
    install_options+=("--force")
    #echo "${install_options[@]}"
    code_launcher "" "$1" install_options
    #sleep 5 
    install_options=()
    #counter+=1
  done
  #code_launcher "" "$1" install_options
  return
}

# Remove unnecessary extension
# Usage:
# uninstall_extensions profile array
# Arguments:
#   profile
#   array extensions for uninstall
# Outputs:
#
# Returns:
#
uninstall_extensions() {
  local -n list_extensions=$2
  local -a uninstall_options
  local -a reverse_list_extensions
  local -i counter=1
  mapfile -t reverse_list_extensions < <( (print_array list_extensions) | sort -r)
  for ext in "${reverse_list_extensions[@]}"; do
    echo "$counter"
    uninstall_options+=("--uninstall-extension")
    uninstall_options+=("$ext")
    echo "${uninstall_options[@]}"
    code_launcher "" "$1" uninstall_options
    uninstall_options=()
    counter+=1
  done
  #array_dump reverse_list_extensions
  #echo "opt:"
  #array_dump uninstall_options
  #code_launcher "" "$1" uninstall_options
  return 
}

update_extensions() {
  local -a launch_arguments
  launch_arguments+=("--update-extensions")
  code_launcher "" "$1" launch_arguments
  return
}

# Calculate the difference between two lists.
# Usage:
# diff_list list_1 list_2 difference
# list_1 - list_2 = difference (for install)
# list_2 - list_1 = difference (for remove)
# Arguments:
#   list_1 (demand)
#   list_2 (installed)
# Outputs:
#   difference
# Returns:
compare_lists() {
  local -n left_list=$1
  local -n right_list=$2
  local -n differences_list=$3
  local -i matching=0
  local right_element
  local left_element
  # take the element of the left list
  for left_element in "${left_list[@]}"; do
    # compare with each element of the right list
    for right_element in "${right_list[@]}"; do
      if [[ "$left_element" == "$right_element" ]]; then
        #echo "$left_element = $right_element"
        matching=1 # fix a match - the element is present in both lists
        break            # finish iterating the right list
      fi
    done
    # if an element from the first list does not match any element from the second list
    if [[ $matching == 0 ]]; then
      # add this item to difference list
      differences_list+=("$left_element")
      # echo "$left_element"
    fi
    matching=0 # reset match flag
  done              # move to the next item from the first list
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

get_length_array() {
  local -n array=$1
  echo ${#array[*]}
}

array_dump() {
  local -ig DEBUG
    if [[ $DEBUG == 1 ]]; then
      local -n array=$1
      echo ""
      echo "${array[*]}"
      echo ""
    fi
}

#log() {
#  locale -g DEBUG
#  if [[ -v DEBUG ]]; then
#  local -n array=$1
#  echo
#  # call and echo get_length_array
#  # call and echo array_dump
#  echo
#  fi
#}

 # Check existence of key in associated array combos
 # Usage:
 # no_exists key
 # Arguments:
 #   associated_array - combo sets
 #   key - as language_id
 # Returns:
 #   exit_code - yes or no language_id
no_exists() {
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

# all required ext's
get_total_list_extensions() {
  local -n top_result=$1
  # local -g combos
  local -n combo_name
  local -a intermediate
  # local ext=""
  # local key
  for combo_name in "${combos[@]}"; do
    echo "${combo_name[@]}" 1 >&/dev/null
    expand_2-dimensional_array combo_name intermediate 
    #get_sets intermediate combo_name
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
  return 
}

return 
