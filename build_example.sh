#!/bin/sh
if [ $# -eq 0 ]; then
    echo
    echo "Syntax: build_example <example number>" >&2
    echo "Note: example number must include leading 0, e.g. 03" >&2
    echo "      If the number matches more than one example folder (e.g. 54 matches 54a and 54b)," >&2
    echo "      all matching examples will be built." >&2
    echo "      If example number is \"all\" (without quotation marks), all examples will be built." >&2
    echo
    exit 1
fi

# These variables are used if examples are built using this bat file
# If you invoke build.bat files in examples' folders manually, values set in
# those files are used instead.
RAYLIB_PATH='/home/my_user/raylib'
RAYLIB_INCLUDE_PATH="${RAYLIB_PATH}/zig-out/include"
RAYLIB_EXTERNAL_INCLUDE_PATH="${RAYLIB_PATH}/src/external"
RAYLIB_LIB_PATH="${RAYLIB_PATH}/zig-out/lib"

# If raylib is installed in a standard location (e.g. /usr/include and /usr/lib/), set these to
# empty strings ('')
#RAYLIB_PATH=''
#RAYLIB_INCLUDE_PATH=''
#RAYLIB_EXTERNAL_INCLUDE_PATH=''
#RAYLIB_LIB_PATH=''

# One of:
# -O Debug
# -O ReleaseFast
# -O ReleaseSafe
# -O ReleaseSmall
RAYLIB_ZIG_BUILD_MODE='-O Debug'

if [ "$1" = 'all' ]; then
    for dir in ./zig-raylib-*/ # list directories
    do
        dir=${dir%*/} # remove the trailing "/"
        echo
        echo "Building ${dir##*/} .."
        cd ${dir}
        # Pass something as the first parameter, as a flag, to signal to build.bat to use variables set here
        source ./build.sh dontuselocals
        cd ..
    done
else
    for dir in ./zig-raylib-$1*/ # list directories
    do
        dir=${dir%*/} # remove the trailing "/"
        echo
        echo "Building ${dir##*/} .."
        cd ${dir}
        # Pass something as the first parameter, as a flag, to signal to build.bat to use variables set here
        source ./build.sh dontuselocals
        cd ..
    done
fi
