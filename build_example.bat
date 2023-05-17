@echo off

if "%~1"=="" (
    echo.
    echo Syntax: build_example ^<example number^>
    echo Note: example number must include leading 0, e.g. 03
    echo       If the number matches more than one example folder (e.g. 54 matches 54a and 54b^),
    echo       all matching examples will be built.
    echo       If example number is "all" (without quotation marks^), all examples will be built.
    exit /b
)

REM These variables are used if examples are built using this bat file
REM If you invoke build.bat files in examples' folders manually, values set in
REM those files are used instead.
SET RAYLIB_PATH=D:\libs\raylib-4.5.0
SET RAYLIB_INCLUDE_PATH=%RAYLIB_PATH%\zig-out\include
SET RAYLIB_EXTERNAL_INCLUDE_PATH=%RAYLIB_PATH%\src\external
SET RAYLIB_LIB_PATH=%RAYLIB_PATH%\zig-out\lib

REM One of:
REM -O Debug
REM -O ReleaseFast
REM -O ReleaseSafe
REM -O ReleaseSmall
SET RAYLIB_ZIG_BUILD_MODE=-O Debug

echo.
REM If parameter is 'all', build all examples
if %1==all (
    echo -- Building all examples --
    echo.
    for /F %%f in ('dir /B /A:D "zig-raylib-*"') do (
        echo Building %%f ..
        cd %%f
        REM Pass something as the first parameter, as a flag, to signal to build.bat to use variables set here
        call build.bat dontuselocals
        cd ..
        echo.
    )
) else (
    REM We assume there's just one zig-raylib-%1* folder,
    REM but if there are more, build them all.
    REM For example, 54a and 54b are built if the user passed '54'.
    for /F %%f in ('dir /B /A:D "zig-raylib-%1*"') do (
        echo Building %%f ..
        cd %%f
        REM Pass something as the first parameter, as a flag, to signal to build.bat to use variables set here
        call build.bat dontuselocals
        cd ..
        echo.
    )
)
