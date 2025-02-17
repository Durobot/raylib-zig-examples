#### Raylib Zig Examples

These are some of [raylib](https://www.raylib.com/) ([raylib on github](https://github.com/raysan5/raylib)) [examples](https://www.raylib.com/examples.html) ported to [Zig](https://ziglang.org/).

[See the screenshot gallery](sshots/sshots.md)!

Please note these are **raylib 4.5** examples, they have been updated to compile with either raylib **4.5**, raylib **5.0** or raylib **5.5**, but the content of example programs has not been updated to match raylib 5.0 or 5.5 examples.

The examples don't use any bindings or some other intermediate layer between Zig code and raylib. Instead, Zig's built-in translate-C feature takes care of everything (well, almost, see below).

For whatever reason, example [27](https://github.com/Durobot/raylib-zig-examples/tree/main/zig-raylib-27-core-custom-frame-control) (custom frame control) does not work properly on Windows, and runs with certain jerkiness on Linux. My knowledge of raylib is not enough to figure out why.

I have done some minor modifications to the code, like changing *camelCase* variable names to *snake_case*, to fit Zig naming conventions.

Some of the examples are presented in multiple versions ([14a](https://github.com/Durobot/raylib-zig-examples/tree/main/zig-raylib-14a-core-3d-picking-(original)) and [14b](https://github.com/Durobot/raylib-zig-examples/tree/main/zig-raylib-14b-core-3d-picking-(2-cubes)); [54a](https://github.com/Durobot/raylib-zig-examples/tree/main/zig-raylib-54a-textures-texture-from-raw-data-(comptime-init)) and [54b](https://github.com/Durobot/raylib-zig-examples/tree/main/zig-raylib-54b-textures-texture-from-raw-data-(runtime-init)); [87a](https://github.com/Durobot/raylib-zig-examples/tree/main/zig-raylib-87a-models-mesh-generation-(MemAlloc-calloc)) and [87b](https://github.com/Durobot/raylib-zig-examples/tree/main/zig-raylib-87b-models-mesh-generation-(Zig-allocator))), see the comments in the Zig code.

To make things easier, some of the examples come with resource files, necessary to run them. Their authors are credited below:

| resource                       | examples                                                     | author                                                       | licence                                                     | notes                                                        |
| ------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ----------------------------------------------------------- | ------------------------------------------------------------ |
| raylib_logo.png                | [46](https://github.com/Durobot/raylib-zig-examples/tree/main/zig-raylib-46-textures-logo-raylib), [50](https://github.com/Durobot/raylib-zig-examples/tree/main/zig-raylib-50-textures-image-loading), [53](https://github.com/Durobot/raylib-zig-examples/tree/main/zig-raylib-53-textures-to-image) | [@raysan5](https://github.com/raysan5) (?)                   | ?                                                           |                                                              |
| fudesumi.raw                   | [54a](https://github.com/Durobot/raylib-zig-examples/tree/main/zig-raylib-54a-textures-texture-from-raw-data-(comptime-init)), [54b](https://github.com/Durobot/raylib-zig-examples/tree/main/zig-raylib-54b-textures-texture-from-raw-data-(runtime-init)) | [Eiden Marsal](https://www.artstation.com/marshall_z)        | [CC-BY-NC](https://creativecommons.org/licenses/by-nc/4.0/) |                                                              |
| road.png                       | [68](https://github.com/Durobot/raylib-zig-examples/tree/main/zig-raylib-68-textures-textured-curve) | ?                                                            | ?                                                           |                                                              |
| fonts/alagard.png              | [69](https://github.com/Durobot/raylib-zig-examples/tree/main/zig-raylib-69-text-raylib-fonts) | Hewett Tsoi                                                  | [Freeware](https://www.dafont.com/es/alagard.font)          | Atlas created by [@raysan5](https://github.com/raysan5)      |
| fonts/alpha_beta.png           | [69](https://github.com/Durobot/raylib-zig-examples/tree/main/zig-raylib-69-text-raylib-fonts) | [Brian Kent (AEnigma)](https://www.dafont.com/es/aenigma.d188) | [Freeware](https://www.dafont.com/es/alpha-beta.font)       | Atlas created by [@raysan5](https://github.com/raysan5)      |
| fonts/jupiter_crash.png        | [69](https://github.com/Durobot/raylib-zig-examples/tree/main/zig-raylib-69-text-raylib-fonts) | [Brian Kent (AEnigma)](https://www.dafont.com/es/aenigma.d188) | [Freeware](https://www.dafont.com/es/jupiter-crash.font)    | Atlas created by [@raysan5](https://github.com/raysan5)      |
| fonts/mecha.png                | [69](https://github.com/Durobot/raylib-zig-examples/tree/main/zig-raylib-69-text-raylib-fonts) | Captain Falcon                                               | [Freeware](https://www.dafont.com/es/mecha-cf.font)         | Atlas created by [@raysan5](https://github.com/raysan5)      |
| fonts/pixantiqua.ttf           | [69](https://github.com/Durobot/raylib-zig-examples/tree/main/zig-raylib-69-text-raylib-fonts) | Gerhard Großmann                                             | [Freeware](https://www.dafont.com/es/pixantiqua.font)       | Atlas created by [@raysan5](https://github.com/raysan5)      |
| fonts/pixelplay.png            | [69](https://github.com/Durobot/raylib-zig-examples/tree/main/zig-raylib-69-text-raylib-fonts) | Aleksander Shevchuk                                          | [Freeware](https://www.dafont.com/es/pixelplay.font)        | Atlas created by [@raysan5](https://github.com/raysan5)      |
| fonts/romulus.png              | [69](https://github.com/Durobot/raylib-zig-examples/tree/main/zig-raylib-69-text-raylib-fonts) | Hewett Tsoi                                                  | [Freeware](https://www.dafont.com/es/romulus.font)          | Atlas created by [@raysan5](https://github.com/raysan5)      |
| fonts/setback.png              | [69](https://github.com/Durobot/raylib-zig-examples/tree/main/zig-raylib-69-text-raylib-fonts) | [Brian Kent (AEnigma)](https://www.dafont.com/es/aenigma.d188) | [Freeware](https://www.dafont.com/es/setback.font)          | Atlas created by [@raysan5](https://github.com/raysan5)      |
| custom_alagard.png             | [70](https://github.com/Durobot/raylib-zig-examples/tree/main/zig-raylib-70-text-font-spritefont) | [Brian Kent (AEnigma)](https://www.dafont.com/es/aenigma.d188) | [Freeware](https://www.dafont.com/es/jupiter-crash.font)    | Atlas created by [@raysan5](https://github.com/raysan5)      |
| custom_jupiter_crash.png       | [70](https://github.com/Durobot/raylib-zig-examples/tree/main/zig-raylib-70-text-font-spritefont) | [Brian Kent (AEnigma)](https://www.dafont.com/es/aenigma.d188) | [Freeware](https://www.dafont.com/es/jupiter-crash.font)    | Atlas created by [@raysan5](https://github.com/raysan5)      |
| custom_mecha.png               | [70](https://github.com/Durobot/raylib-zig-examples/tree/main/zig-raylib-70-text-font-spritefont) | [Brian Kent (AEnigma)](https://www.dafont.com/es/aenigma.d188) | [Freeware](https://www.dafont.com/es/jupiter-crash.font)    | Atlas created by [@raysan5](https://github.com/raysan5)      |
| KAISG.ttf                      | [71](https://github.com/Durobot/raylib-zig-examples/tree/main/zig-raylib-71-text-font-filters) | [Dieter Steffmann](http://www.steffmann.de/wordpress/)       | [Freeware](https://www.1001fonts.com/users/steffmann/)      | [Kaiserzeit Gotisch](https://www.dafont.com/es/kaiserzeit-gotisch.font) font |
| pixantiqua.fnt, pixantiqua.png | [72](https://github.com/Durobot/raylib-zig-examples/tree/main/zig-raylib-72-text-font-loading) | Gerhard Großmann                                             | [Freeware](https://www.dafont.com/es/pixantiqua.font)       | Atlas made with [BMFont](https://www.angelcode.com/products/bmfont/) by [@raysan5](https://github.com/raysan5) |
| pixantiqua.ttf                 | [72](https://github.com/Durobot/raylib-zig-examples/tree/main/zig-raylib-72-text-font-loading) | Gerhard Großmann                                             | [Freeware](https://www.dafont.com/es/pixantiqua.font)       |                                                              |
| cubicmap.png                   | [84](https://github.com/Durobot/raylib-zig-examples/tree/main/zig-raylib-84-models-cubicmap), [85](https://github.com/Durobot/raylib-zig-examples/tree/main/zig-raylib-85-models-first-person-maze) | [@raysan5](https://github.com/raysan5)                       | [CC0](https://creativecommons.org/publicdomain/zero/1.0/)   |                                                              |
| cubicmap_atlas.png             | [84](https://github.com/Durobot/raylib-zig-examples/tree/main/zig-raylib-84-models-cubicmap), [85](https://github.com/Durobot/raylib-zig-examples/tree/main/zig-raylib-85-models-first-person-maze) | [@emegeme](https://github.com/emegeme)                       | [CC0](https://creativecommons.org/publicdomain/zero/1.0/)   |                                                              |



#### Building the examples

**Note**: some examples require additional header files. I recommend downloading them to the corresponding example's folder, as described in the comments in Zig code.

Examples [39](https://github.com/Durobot/raylib-zig-examples/tree/main/zig-raylib-39-shapes-easings-ball_anim), [40](https://github.com/Durobot/raylib-zig-examples/tree/main/zig-raylib-40-shapes-easings-box_anim), [41](https://github.com/Durobot/raylib-zig-examples/tree/main/zig-raylib-41-shapes-easings-rectangle_array) need `reasings.h` from https://github.com/raysan5/raylib/blob/master/examples/others/reasings.h; examples [42](https://github.com/Durobot/raylib-zig-examples/tree/main/zig-raylib-42-shapes-draw-ring), [43](https://github.com/Durobot/raylib-zig-examples/tree/main/zig-raylib-43-shapes-draw-circle_sector), [44](https://github.com/Durobot/raylib-zig-examples/tree/main/zig-raylib-44-shapes-draw-rectangle_rounded) need `raygui.h` from https://github.com/raysan5/raygui/blob/master/src/raygui.h.

In other words, the following additional header files are necessary for their respective examples to build:

```
zig-raylib-39-shapes-easings-ball_anim/reasings.h
zig-raylib-40-shapes-easings-box_anim/reasings.h
zig-raylib-41-shapes-easings-rectangle_array/reasings.h
zig-raylib-42-shapes-draw-ring/raygui.h
zig-raylib-43-shapes-draw-circle_sector/raygui.h
zig-raylib-44-shapes-draw-rectangle_rounded/raygui.h
```

**On Linux**:

1. Install Zig - download from https://ziglang.org/download/.
   
   Versions that work are **0.12.0**, **0.12.1**, **0.13.0** (current stable release), and **0.14.0** (nightly development build). **0.11.0** probably still works too (*come on, really? 0.11?*), but this may change in the future.
   
   Latest version of Zig **0.14.0** I have tested the project with was **0.14.0-dev.3237+ddff1fa4c**. Later versions may or may not work, you're welcome to try them and raise an issue on github if they don't.
   
   Unpack your version of Zig and add its folder to environment variable PATH. In many Linux distributions this is done by adding the following line to the end of `.bashrc` file in your home folder (replace /path/to/zig with the `actual` path, of course):
   
   `export PATH="$PATH:/path/to/zig"`
   
   Alternatively, you can install Zig from your distribution's repositories, if they contain Zig 0.12 and up.
   
2. Install raylib. Versions 4.5 and 5.0 do work. Earlier or later version may work too. Use one of the following methods:
   
   1. Install it from your distribution's repositories. For example on Arch you can do it with `pacman -S raylib` command.
   
      You then should be able to build examples by running `zig build-exe main.zig -lc -lraylib` in each example's folder. To build using `build_example.sh`, (optionally) edit this file, setting `RAYLIB_PATH`, `RAYLIB_INCLUDE_PATH`, `RAYLIB_EXTERNAL_INCLUDE_PATH` and `RAYLIB_LIB_PATH` variables to '' (empty string). To build using `build.sh` found in each folder, (optionally) edit build.sh, setting `tmp_raylib_path`, `tmp_raylib_include_path`, `tmp_raylib_external_include_path` and `tmp_raylib_lib_path` variables to '' (empty string) at lines 12 - 15.
   
       Alternatively, you can
   
   2. Build raylib from source code. Download raylib [from github](https://github.com/raysan5/raylib/tags). Click "tar.gz" under the release you want to download, or click "Downloads", then scroll down and click "Source code (tar.gz)". Unpack the downloaded archive.
   
      Now, in order to make raylib and/or raylib-zig-examples compile without errors, do one of the following, depending on your version of raylib:
      
      1. **If** you're using raylib **5.0**, open `src\build.zig`, find lines containing `lib.installHeader` (they should be in `pub fn build`), and add the following line after them:
      
         ```zig
         lib.installHeader("src/rcamera.h", "rcamera.h");
         ```
      
         Otherwise example 13 won't compile.
      
      2. **If** you're using raylib **4.5**, do one of the following:
      
         a. **If** `build.zig` in raylib root folder **contains** the following lines:
      
         ```zig
         const lib = raylib.addRaylib(b, target, optimize);
         lib.installHeader("src/raylib.h", "raylib.h");
         lib.install();
         ```
      
         then edit this file - remove or comment out this line: `lib.install();`
         Add these lines below it, before the closing `}`:
      
         ```zig
         lib.installHeader("src/rlgl.h", "rlgl.h");
         lib.installHeader("src/raymath.h", "raymath.h");
         lib.installHeader("src/rcamera.h", "rcamera.h");
         b.installArtifact(lib);
         ```
      
         b. **If**, on the other hand, `build.zig` in raylib's root folder **does not** contain `lib.install();` (see [this commit](https://github.com/raysan5/raylib/commit/6b92d71ea1c4e3072b26f25e7b8bd1d1aa8e781f)), then in `src/build.zig`, in function `pub fn build(b: *std.Build) void`, after `lib.installHeader("src/raylib.h", "raylib.h");`, add these lines:
      
         ```zig
         lib.installHeader("src/rlgl.h", "rlgl.h");
         lib.installHeader("src/raymath.h", "raymath.h");
         lib.installHeader("src/rcamera.h", "rcamera.h");
         ```
      
      In raylib root folder, run `zig build -Doptimize=ReleaseSmall` or `zig build -Doptimize=ReleaseFast`. You could also use `-Doptimize=ReleaseSafe`, `-Doptimize=Debug` or simply run `zig build`.
      
      This should create `zig-out` folder, with two folders inside: `include` and `lib`, these contain raylib header files and static library, respectively.
      
      In `raylib-zig-examples`, in `build_example.sh`set `RAYLIB_PATH` variable to the correct raylib path and make sure the values of `RAYLIB_INCLUDE_PATH`, `RAYLIB_EXTERNAL_INCLUDE_PATH` and `RAYLIB_LIB_PATH` make sense.
   
3. Build the examples.  You can use `build_example.sh` to either build individual examples by providing the example number, e.g. `./build_example.sh 03`, or build them all: `./build_example.sh all`.

   You can also run `build.sh` contained in each example's folder. raylib paths and Zig build mode set within each build.sh are used in this case.

   `clean_all.sh` and `clean.sh` in examples' folders can be used to delete binaries generated by the compiler.

**On Windows**:

1. Install Zig - download from https://ziglang.org/download/.
   
   Versions that work are **0.12.0**, **0.12.1**, **0.13.0** (current stable release), and **0.14.0** (nightly development build). **0.11.0** probably still works too (*come on, really? 0.11?*), but this may change in the future.

   Latest version of Zig **0.14.0** I have tested the project with was **0.14.0-dev.3237+ddff1fa4c**. Later versions may or may not work, you're welcome to try them and raise an issue on github if they don't.

   Unpack your version of Zig and add its folder to environment variable PATH.

2. Install raylib. These examples were built using raylib 4.5.0, but an earlier or later version may work too. 

   Build raylib from source code. Download raylib [from github](https://github.com/raysan5/raylib/tags). Click "zip" under the release you want to download, or click "Downloads", then scroll down and click "Source code (zip)".

   Unpack the downloaded archive. Now, in order to make raylib and/or raylib-zig-examples compile without errors, do one of the following, depending on your version of raylib:

   1. **If** you're using raylib **5.0**, open `src\build.zig`, find lines containing `lib.installHeader` (they should be in `pub fn build`), and add the following line after them:

      ```zig
      lib.installHeader("src/rcamera.h", "rcamera.h");
      ```

      Otherwise example 13 won't compile.

   2. **If** you're using raylib **4.5**, do one of the following:

      a. **If** `build.zig` in raylib root folder **contains** the following lines:

      ```zig
      const lib = raylib.addRaylib(b, target, optimize);
      lib.installHeader("src/raylib.h", "raylib.h");
      lib.install();
      ```

      then edit this file - remove or comment out this line: `lib.install();`
      Add these lines below it, before the closing `}`:

      ```zig
      lib.installHeader("src/rlgl.h", "rlgl.h");
      lib.installHeader("src/raymath.h", "raymath.h");
      lib.installHeader("src/rcamera.h", "rcamera.h");
      b.installArtifact(lib);
      ```

      b. **If**, on the other hand, `build.zig` in raylib's root folder **does not** contain `lib.install();` (see [this commit](https://github.com/raysan5/raylib/commit/6b92d71ea1c4e3072b26f25e7b8bd1d1aa8e781f)), then in `src/build.zig`, in function `pub fn build(b: *std.Build) void`, after `lib.installHeader("src/raylib.h", "raylib.h");`, add these lines:

      ```zig
      lib.installHeader("src/rlgl.h", "rlgl.h");
      lib.installHeader("src/raymath.h", "raymath.h");
      lib.installHeader("src/rcamera.h", "rcamera.h");
      ```

   In raylib root folder, run `zig build -Doptimize=ReleaseSmall` or `zig build -Doptimize=ReleaseFast`.

      **Warning**: leaving out `-Doptimize` parameter, using `-Doptimize=Debug` or `-Doptimize=ReleaseSafe` currently causes compilation of raylib-zig-examples to fail in ReleaseSmall and ReleaseFast modes down the road. You will see errors similar to these:

   ```
   error: lld-link: undefined symbol: __stack_chk_fail
   error: lld-link: undefined symbol: __stack_chk_guard
   ```

   Running zig build... should create `zig-out` folder, with two folders inside: `include` and `lib`, these contain raylib header files and static library, respectively.

   In `raylib-zig-examples`, in `build_example.bat`set `RAYLIB_PATH` variable to the correct raylib path and make sure the values of `RAYLIB_INCLUDE_PATH`, `RAYLIB_EXTERNAL_INCLUDE_PATH` and `RAYLIB_LIB_PATH` make sense.

3. Build the examples.  You can use `build_example.bat` to either build individual examples by providing the example number, e.g. `build_example.bat 03`, or build them all: `build_example.bat all`.

   You can also run `build.bat` contained in each example's folder. raylib paths and Zig build mode set within each build.bat are used in this case.

   `clean_all.bat` and `clean.bat` in examples' folders can be used to delete binaries generated by the compiler.
