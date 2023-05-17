#!/bin/sh
for dir in ./zig-raylib-*/ # list directories
do
    dir=${dir%*/} # remove the trailing "/"
    echo
    echo "Cleaning ${dir##*/} .."
    cd ${dir}
    source ./clean.sh
    cd ..
done
echo 'Done'
