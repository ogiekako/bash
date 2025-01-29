# Usage: source <(curl -L https://github.com/ogiekako/bash/raw/refs/heads/main/lib.sh)

# Allow to pass stdin as the first parameter.
relax() {
  local f="$1"
  local body="$(type $f | tail +3)"
  local impl="${f}_impl"
  local n=0
  while echo $body | grep "\$$((n+1))" > /dev/null ; do n=$((n+1)); done

  eval "$f() {
  case \$# in
    $n) '${impl}' \"\$@\";;
    $(($n+1))) {
      local first=\"\$1\"
      shift
      echo \"\$first\" | '${impl}' \"\$@\"
    } ;;
    *) {
      echo \"Unexpected args: $f \$@\"
      exit 1
    } ;;
  esac
}

$impl() $body"
}

# str APIs

str::eq() {
  [ "$(cat)" == "$1" ]
}
relax str::eq

str::char_at() {
  local s="$(cat)"
  echo "${s:$1:1}"
}
relax str::char_at

str::char_code_at() {
  local s="$(cat)"
  LC_CTYPE=C printf '%d' "'$(str::char_at "$s" "$1")"
}
relax str::char_code_at

str::ends_with() {
  [[ "$(cat)" == *"$1" ]]
}
relax str::ends_with

str::includes() {
  [[ "$(cat)" == *"$1"* ]]
}
relax str::includes

str::index_of() {
  local s="$(cat)"
  if str::eq "$1" ""; then
    echo 0
    return
  fi
  local prefix="${s%%$1*}"
  if str::eq "$prefix" "$s"; then
    echo -1
    return
  fi
  str::length "$prefix"
}
relax str::index_of

str::last_index_of() {
  local s="$(cat)"
  if str::eq "$1" ""; then
    str::length "$s"
    return
  fi
  local prefix="${s%$1*}"
  if str::eq "$prefix" "$s"; then
    echo -1
    return
  fi
  str::length "$prefix"
}
relax str::last_index_of

str::starts_with() {
  [[ "$(cat)" == "$1"* ]]
}
relax str::starts_with

str::substring() {
  local s
  if [[ "$#" == 3 || "$#" == 2 && ! "$1" =~ ^[[:digit:]]+$ ]]; then
    s="$1"
    shift
  else
    s="$(cat)"
  fi
  local end="${#s}"
  if str::eq "$#" 2; then
    end="$2"
  fi
  echo "${s:"$1":$(( "$end" - "$1" ))}"
}

str::to_lower_case() {
  local s="$(cat)"
  echo "${s,,}"
}
relax str::to_lower_case

str::to_upper_case() {
  local s="$(cat)"
  echo "${s^^}"
}
relax str::to_upper_case

str::trim() {
  str::trim_start | str::trim_end
}
relax str::trim

str::trim_end() {
  local s="$(cat)"
  local n="${#s}"
  while [[ "${s:$n}" =~ ^[[:space:]]*$ ]]; do
    if [[ $n == 0 ]]; then
      echo ""
      return
    fi
    n="$((n-1))"
  done
  echo "${s:0:$(($n + 1))}"
}
relax str::trim_end

str::trim_start() {
  local s="$(cat)"
  local n=0
  while [[ "${s:0:$n}" =~ ^[[:space:]]*$ ]]; do
    if [[ $n == "${#s}" ]]; then
      echo ""
      return
    fi
    n=$((n+1))
  done
  echo "${s:$(($n - 1))}"
}
relax str::trim_start

str::length() {
  local s="$(cat)"
  echo "${#s}"
}
relax str::length

str::split() {
  tr "$1" '\n'
}
relax str::split

str::join() {
  paste -sd "$1"
}
relax str::join

str::capitalize() {
  while read -r i; do
    echo "${i^}"
  done
}
relax str::capitalize

str::uncapitalize() {
  while read -r i; do
    echo "${i,}"
  done
}
relax str::uncapitalize

str::camel_to_snake() {
  sed -E 's/(.)([A-Z])/\1_\2/g' | tr '[A-Z]' '[a-z]'
}
relax str::camel_to_snake

str::snake_to_camel() {
  str::split "_" | str::capitalize | str::join '' | str::uncapitalize
}
relax str::snake_to_camel

# map APIs

map::new() {
  echo "Use declare -A ; see https://www.gnu.org/software/bash/manual/bash.html#Arrays" >&2
  return 1
}

map::clear() {
  local __map_clear_key
  eval "for __map_clear_key in \"\${!$1[@]}\"; do
  map::delete $1 \"\${__map_clear_key}\"
done
"
}

map::delete() {
  unset "$1[$2]"
}

map::get() {
  eval "echo \"\${$1['$2']}\""
}

map::has() {
  map::keys "$1" | {
    while IFS= read -r s; do
      if str::eq "$s" "$2"; then
        return 0
      fi
    done
    return 1
  }
}

map::keys() {
  eval "printf '%s\n' \"\${!$1[@]}\""
}

map::set() {
  eval "$1['$2']='$3'"
}

map::values() {
  eval "printf '%s\n' \"\${$1[@]}\""
}

map::size() {
  eval "echo \"\${#$1[@]}\""
}

unset -f relax
