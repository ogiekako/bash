#!/bin/bash -eux

cd "$(dirname -- "$0")"
source ./lib.sh

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

echo ok
