#!/usr/bin/env bash
set -eu
LC_NUMERIC=C
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/helpers.sh"

storage_view_tmpl=$(get_tmux_option "@storage_view_tmpl" 'storage:#[fg=#{storage.color}]#{storage.free}/#{storage.total}#[default]')

storage_medium_threshold=$(get_tmux_option "@storage_medium_threshold" "75")
storage_stress_threshold=$(get_tmux_option "@storage_stress_threshold" "90")

storage_color_low=$(get_tmux_option "@storage_color_low" "green")
storage_color_medium=$(get_tmux_option "@storage_color_medium" "yellow")
storage_color_stress=$(get_tmux_option "@storage_color_stress" "red")

get_storage_color() {
  local storage_pused=$1

  if fcomp "$storage_stress_threshold" "$storage_pused"; then
    echo "$storage_color_stress";
  elif fcomp "$storage_medium_threshold" "$storage_pused"; then
    echo "$storage_color_medium";
  else
    echo "$storage_color_low";
  fi
}

print_storage() {
  local storage_usage=$(get_storage_usage)
  local storage_size_unit=$(echo $storage_usage | awk '{print $3}')
  local storage_free=$(echo $storage_usage | awk '{ print $1}')
  local storage_total=$(echo $storage_usage | awk '{ print $2}')
  local storage_used=$(echo "$storage_total - $storage_free" | calc)
  local storage_pused=$(echo "($storage_used / $storage_total) * 100" | calc)
  local storage_pfree=$(echo "($storage_free / $storage_total) * 100" | calc)
  local storage_color=$(get_storage_color "$storage_pused") 
  local storage_view="$storage_view_tmpl"

  storage_view="${storage_view//'#{storage.used}'/$(printf "$storage_used""$storage_size_unit")}"
  storage_view="${storage_view//'#{storage.pused}'/$(printf "$storage_pused")}"
  storage_view="${storage_view//'#{storage.free}'/$(printf "$storage_free""$storage_size_unit")}"
  storage_view="${storage_view//'#{storage.pfree}'/$(printf "$storage_pfree")}"
  storage_view="${storage_view//'#{storage.total}'/$(printf "$storage_total""$storage_size_unit")}"
  storage_view="${storage_view//'#{storage.color}'/$(echo "$storage_color" | awk '{ print $1 }')}"
  storage_view="${storage_view//'#{storage.color2}'/$(echo "$storage_color" | awk '{ print $2 }')}"
  storage_view="${storage_view//'#{storage.color3}'/$(echo "$storage_color" | awk '{ print $3 }')}"

  echo "$storage_view"
}

get_storage_usage(){
  df -H | awk -F ' ' '
    NR==1 {
      for (i=1; i<=NF; i++) {
        col[$i] = i
      }
    }
    {
      for (i=1; i<=NF; i++) {
        if ($i=="/") {
          total=substr($(col["Size"]), 1, length($(col["Size"]))-1)
          free=substr($(col["Avail"]), 1, length($(col["Avail"]))-1)
          size_unit=substr($(col["Avail"]), length($(col["Avail"])), length($(col["Avail"])))
        }
      }
    }
    END {print free, total, size_unit}
  '
}

main() {
  print_storage
}

main
