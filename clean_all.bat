@echo off
for /F %%f in ('dir /B /A:D "zig-raylib-*"') do (
    echo Cleaning %%f ..
    cd %%f
    call clean.bat
    cd ..
    echo.
)
echo Done
@echo on
