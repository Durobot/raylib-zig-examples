#!/bin/sh
tmp_raylib_include_path=''
tmp_raylib_external_include_path=''
tmp_raylib_lib_path=''
tmp_raylib_zig_build_mode=''

# No command line arguments => use local variables
if [ $# -eq 0 ]; then
    echo
    echo 'Using locally defined build variables and paths'
    # Set the paths here if you invoke this build.sh manually
    tmp_raylib_path='~/ray'
    tmp_raylib_include_path="${tmp_raylib_path}/zig-out/include"
    tmp_raylib_external_include_path="${tmp_raylib_path}/src/external"
    tmp_raylib_lib_path="${tmp_raylib_path}/zig-out/lib"
    # One of:
    # -O Debug
    # -O ReleaseFast
    # -O ReleaseSafe
    # -O ReleaseSmall
    tmp_raylib_zig_build_mode='-O ReleaseSmall'
else
    # Using variables set in ../build_example.sh
    tmp_raylib_include_path=$RAYLIB_INCLUDE_PATH
    tmp_raylib_external_include_path=$RAYLIB_EXTERNAL_INCLUDE_PATH
    tmp_raylib_lib_path=$RAYLIB_LIB_PATH
    tmp_raylib_zig_build_mode=$RAYLIB_ZIG_BUILD_MODE
fi

tmp_raylib_include_arg=''

if [ -n "$tmp_raylib_include_path" ]; then # Not empty
    tmp_raylib_include_arg="-idirafter ${tmp_raylib_include_path}"
fi

if [ -n "$tmp_raylib_external_include_path" ]; then # Not empty
    tmp_raylib_include_arg="${tmp_raylib_include_arg} -idirafter ${tmp_raylib_external_include_path}"
fi

#echo 'tmp_raylib_include_arg = '
#echo "$tmp_raylib_include_arg"

tmp_raylib_lib_arg=''

if [ -n "$tmp_raylib_lib_path" ]; then # Not empty
    tmp_raylib_lib_arg="-L${tmp_raylib_lib_path} -lc -lraylib"
else
    tmp_raylib_lib_arg='-lc -lraylib'
fi

#echo 'tmp_raylib_lib_arg = '
#echo "$tmp_raylib_lib_arg"

echo "zig build-exe main.zig raygui_impl.c ${tmp_raylib_zig_build_mode} ${tmp_raylib_include_arg} -idirafter ./ ${tmp_raylib_lib_arg}"
zig build-exe main.zig raygui_impl.c ${tmp_raylib_zig_build_mode} ${tmp_raylib_include_arg} -idirafter ./ ${tmp_raylib_lib_arg}
