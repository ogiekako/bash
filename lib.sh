# Usage: source <(curl -L https://github.com/ogiekako/bash/raw/refs/heads/main/lib.sh)

# Allow to pass stdin as the first parameter.
relax() {
  local f="$1"
  local body="$(type $f | tail +3)"
  local impl="${f}_impl"
  local n=0
  while echo $body | grep "\$$((n+1))"; do n=$((n+1)); done

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

str::eq() {
  [ "$(cat)" == "$1" ]
}
relax str::eq

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

unset -f relax
