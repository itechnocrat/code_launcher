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
  #mapfile -t list_installed < <( (code_launcher "" "$1" options) | tr ' ' '\n' | sort)
  mapfile -t list_installed < <( (code_launcher "" "$1" options) | tr ' ' '\n')
  #mapfile -t list_installed < <( (print_array acc) | sort)
  return $?
}

print_array() {
  local -n array=$1
  for item in "${array[@]}"; do
    printf "%s\n" "$item"
  done
}

# Expands two-dimensional array into one.
# Usage: expand_array_x2 array_x2 array
# Arguments:
#   array_x2
# Outputs:
#   array
# Returns:
expand_array_x2() {
  local -n in_array_x2=$1
  local -n out_array=$2
  local -n array
  local element
  for array in "${in_array_x2[@]}"; do
    for element in "${array[@]}"; do
      out_array+=("$element")
    done
  done
  return 
}

# Wrapper for get_sets
# Prepares a request and accepts the result
# Usage:
# get_list_exts_fo key associated_array array
# Arguments:
# key                 @ string Language name as key of combos array
# associated_array    @ ref to array
# Outputs:            @ array
# Returns:  
get_list_exts_for() {
  local key="$1"
  local -n input_array_x3=$2
  local -n output_array=$3
  local -n array_x2
  local -a acc
  array_x2="${input_array_x3[$key]}"
  expand_array_x2 array_x2 acc 
  #expand_array_x2 array_x2 output_array 
  #mapfile -t output_array < <( (print_array acc) | sort | uniq)
  mapfile -t output_array < <( (print_array acc) | uniq)
  acc=()
}

# all required ext's
expand_array_x3() {
  local -n input_array_x3=$1 
  local -n result_array=$2
  local -n array_x2
  local -a acc
  #local -a acc2
  for array_x2 in "${input_array_x3[@]}"; do
    expand_array_x2 array_x2 acc 
    #acc2+=("${acc[@]}")
  done
  #mapfile -t result_array < <( (print_array acc2) | sort | uniq)
  mapfile -t result_array < <( (print_array acc) | uniq)
  return 
}

#merge_arrays() {
#  local -n array_1=$1
#  local -n array_2=$2
#  local -n array_3=$3
#  local -a acc
#  #for element in "${array_1[@]}"; do
#  #  acc+=("$element")
#  #done
#  #for element in "${array_2[@]}"; do
#  #  acc+=("$element")
#  #done
#  array_3=("${array_1[@]}" "${array_2[@]}")
#  #array_3+=("${array_2[@]}")
#  #mapfile -t array_3 < <( (print_array acc) | sort | uniq)
#  #mapfile -t array_3 < <( (print_array acc) | uniq)
#  return 
#}

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
  echo
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
  #local -i counter=1
  mapfile -t reverse_list_extensions < <( (print_array list_extensions) | sort -r)
  #mapfile -t reverse_list_extensions < <( (print_array list_extensions) | sort)
  #echo "${reverse_list_extensions[@]}"
  for ext in "${reverse_list_extensions[@]}"; do
    #echo "$counter"
    uninstall_options+=("--uninstall-extension")
    uninstall_options+=("$ext")
    #echo "${uninstall_options[@]}"
    code_launcher "" "$1" uninstall_options
    uninstall_options=()
    #counter+=1
  done
  #array_dump reverse_list_extensions
  #echo "opt:"
  #array_dump uninstall_options
  #code_launcher "" "$1" uninstall_options
  echo
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
  local -n remainder_list=$3
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
      remainder_list+=("$left_element")
      # echo "$left_element"
    fi
    matching=0 # reset match flag
  done              # move to the next item from the first list
  return 
}
# Returns:
diff_lists() {
  local -n l_list=$1
  local -n r_list=$2
  local -n l_list_remainder=$3
  local -n r_list_remainder=$4
  local r_element
  local l_element
  local -i matching=0

  for l_element in "${l_list[@]}"; do
    for r_element in "${r_list[@]}"; do
      if [[ "$l_element" == "$r_element" ]]; then
        matching=1
        break
      fi
    done
    if [[ $matching == 0 ]]; then
      l_list_remainder+=("$l_element")
      # echo "$l_element"
    fi
    matching=0
  done

  matching=0
  for r_element in "${r_list[@]}"; do
    for l_element in "${l_list[@]}"; do
      if [[ "$r_element" == "$l_element" ]]; then
        matching=1
        break
      fi
    done
    if [[ $matching == 0 ]]; then
      r_list_remainder+=("$r_element")
      # echo "$r_element"
    fi
    matching=0
  done

  return 
}

#get_length_array() {
#  local -n in_array=$1
#  echo ${#in_array[*]}
#}

#array_dump() {
#  local -ig DEBUG
#    if [[ $DEBUG == 1 ]]; then
#      local -n array=$1
#      echo ""
#      echo "${array[*]}"
#      echo ""
#    fi
#}

get_max_length_element() {
 local -n input_array=$1
 local -i max_length=1
 local -i length
 local element
 for element in "${input_array[@]}"; do
   length=${#element}
   if [[ $length -gt $max_length ]]; then
     max_length=$length
   fi
 done
 printf "%i" $max_length
}

log() {
  local -ig DEBUG
  if [[ $DEBUG == 1 ]]; then
    local -n list=$1
    local msg=$2
    echo -e "${YELLOW}$msg${RESET} (${YELLOW}${#list[*]}${RESET}):"
    #
    echo "${list[@]}"
    #echo ""
    #
    #local -a tmp_array
    #mapfile -t tmp_array < <( (print_array list) | sort -r)
    #echo "${tmp_array[@]}"
    #local -i screen_width
    #local -i number_columns
    #local -i max_length_element
    #local -i counter=0
    #local -i i
    #local element=""

    #screen_width=$(/usr/bin/tput cols)
    #max_length_element=$(get_max_length_element list)
    ##number_columns=$(( screen_width/(max_length_element+2) ))
    #number_columns=2
    ##echo "Diag"
    ##echo "Screen width= $screen_width"
    ##echo "Number columns= $number_columns"

    #for element in "${list[@]}"; do
    #	printf "%s" "$element"
    #	for i in $(seq 0 $(( max_length_element-${#element} )) ); do
    #		printf "%c" " "
    #	done
    #	counter+=1
    #	if [[ $number_columns == "$counter"  ]]; then
    #		printf "\n"
    #		counter=0
    #	fi
    #done
    #printf "\n"
  fi
}

 # Check existence of key in associated array
 # Usage:
 # exists key array
 # Arguments:
 #   key   - string is language_id
 #   array - associated array
 # Returns:
 #   exit_code - 1 - yes or 0 - no language_id
exists() {
   local key_being_checked=$1
   local array_x3=$2
   local key
   for key in "${!array_x3[@]}"; do
     if [[ "$key_being_checked" == "$key" ]]; then
       return 1
     fi
   done
   return 0
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

return 
