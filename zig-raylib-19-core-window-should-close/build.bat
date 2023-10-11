@echo off

REM First parameter not set = build.bat launched manually
if "%~1"=="" (
    echo.
    echo Using locally defined build variables and paths
    setlocal enableDelayedExpansion

    REM These values are used if you invoke this build.bat file manualy.
    REM If you use build_example.bat in the root folder, values set in that file are used.
    SET RAYLIB_PATH=D:\libs\raylib-4.5.0
    SET RAYLIB_INCLUDE_PATH=!RAYLIB_PATH!\zig-out\include
    SET RAYLIB_EXTERNAL_INCLUDE_PATH=!RAYLIB_PATH!\src\external
    SET RAYLIB_LIB_PATH=!RAYLIB_PATH!\zig-out\lib

    REM One of:
    REM -O Debug
    REM -O ReleaseFast
    REM -O ReleaseSafe
    REM -O ReleaseSmall
    SET RAYLIB_ZIG_BUILD_MODE=-O ReleaseSmall
)

REM echo RAYLIB_PATH: %RAYLIB_PATH%
REM echo RAYLIB_INCLUDE_PATH: %RAYLIB_INCLUDE_PATH%
REM echo RAYLIB_EXTERNAL_INCLUDE_PATH: %RAYLIB_EXTERNAL_INCLUDE_PATH%
REM echo RAYLIB_LIB_PATH: %RAYLIB_LIB_PATH%
REM echo RAYLIB_ZIG_BUILD_MODE: %RAYLIB_ZIG_BUILD_MODE%

@echo on

zig build-exe main.zig %RAYLIB_ZIG_BUILD_MODE% -idirafter .\ -idirafter %RAYLIB_INCLUDE_PATH% -idirafter %RAYLIB_EXTERNAL_INCLUDE_PATH% -L%RAYLIB_LIB_PATH% -lraylib -lopengl32 -lgdi32 -lwinmm -lc

@echo off

REM End local variables scope if not called from the main script
if "%~1"=="" (
    endlocal & (
        SET RAYLIB_PATH=%RAYLIB_PATH%
        SET RAYLIB_INCLUDE_PATH=%RAYLIB_INCLUDE_PATH%
        SET RAYLIB_EXTERNAL_INCLUDE_PATH=%RAYLIB_EXTERNAL_INCLUDE_PATH%
        SET RAYLIB_LIB_PATH=%RAYLIB_LIB_PATH%
        SET RAYLIB_ZIG_BUILD_MODE=%RAYLIB_ZIG_BUILD_MODE%
    )
)
