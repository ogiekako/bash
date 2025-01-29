#!/bin/bash -eux

LC_ALL=C

cd "$(dirname -- "$0")"
source ./lib.sh

str::eq "" ""
! str::eq "" a
! str::eq a ""
str::eq a a
echo -n a | str::eq a

echo a:b | str::split : | str::eq 'a
b'
str::split a:b : | str::eq 'a
b'

str::join 'a
b' ':' | str::eq 'a:b'
str::split a:b : | str::join : | str::eq a:b

str::camel_to_snake fooBar | str::eq foo_bar
str::snake_to_camel foo_bar_baz | str::eq fooBarBaz
echo fooBarX | str::camel_to_snake | str::eq foo_bar_x

str::char_at abc 0 | str::eq a
str::char_at abc 1 | str::eq b
str::char_at abc 2 | str::eq c

str::char_code_at "abc" 1 | str::eq 98

str::ends_with "" ""
str::ends_with "abc" "c"
! str::ends_with "abc" "b"

str::includes "abc" "b"
! str::includes "abc" "cb"

str::index_of "abb" "" | str::eq 0
str::index_of "abb" "b" | str::eq 1
str::index_of "abb" "ba" | str::eq -1

str::last_index_of "abb" "" | str::eq 3
str::last_index_of "abb" "b" | str::eq 2
str::last_index_of "abb" "ba" | str::eq -1

str::starts_with "abc" ""
str::starts_with "abc" "a"
! str::starts_with "abc" "c"

str::substring "abc" 1 2 | str::eq b
str::substring "abc" 3 3 | str::eq ""
str::substring "abc" 1 | str::eq bc
str::substring a12 1 | str::eq 12
str::substring a12 1 2 | str::eq 1

str::to_lower_case "AbCd " | str::eq "abcd "
str::to_upper_case "AbCd " | str::eq "ABCD "

str::trim " abc " | str::eq abc
str::trim "" | str::eq ""
str::trim "  " | str::eq ""
str::trim_end " abc " | str::eq " abc"
str::trim_end "" | str::eq ""
str::trim_end " " | str::eq ""
str::trim_start " abc " | str::eq "abc "
str::trim_start "" | str::eq ""
str::trim_start " " | str::eq ""

str::length "" | str::eq 0
str::length " " | str::eq 1
str::length "abc" | str::eq 3

declare -A m=( ['a']=1 ['b']=2 [' c ']=' 3 ' )
declare -A s=( ['s']=t )
map::has m a
! map::has m b
map::has m ' c '

map::has s s
map::clear s
! map::has s s

map::set s s t
map::has s s
map::delete s s
! map::has s s
map::set s s t
map::get s s | str::eq t
map::set s s u
map::get s s | str::eq u

map::keys m | sort | str::eq 'a
b
 c '
map::values m | sort | str::eq '1
2
 3 '

map::size m | str::eq 3
map::clear m
map::size m | str::eq 0

map::set m '
x
 x' ' y

y'
! map::has m x
map::get m '
x
 x' | str::eq ' y

y'
map::size m | str::eq 1
map::clear m
map::size m | str::eq 0
map::clear m
map::size m | str::eq 0

echo ok
