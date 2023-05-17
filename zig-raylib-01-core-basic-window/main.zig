// build with `zig build-exe main.zig -lc -lraylib`

// This is a Zig version of a raylib example from
// https://github.com/raysan5/raylib/
// It is distributed under the same license as the original - unmodified zlib/libpng license
// Header from the original source code follows below:

///*******************************************************************************************
//*
//*   raylib [core] example - Basic window
//*
//*   Welcome to raylib!
//*
//*   To test examples, just press F6 and execute raylib_compile_execute script
//*   Note that compiled executable is placed in the same folder as .c file
//*
//*   You can find all basic examples on C:\raylib\raylib\examples folder or
//*   raylib official webpage: www.raylib.com
//*
//*   Enjoy using raylib. :)
//*
//*   Example originally created with raylib 1.0, last time updated with raylib 1.0
//*
//*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//*   BSD-like license that allows static linking with closed source software
//*
//*   Copyright (c) 2013-2023 Ramon Santamaria (@raysan5)
//*
//********************************************************************************************/

const ray = @cImport(
{
    @cInclude("raylib.h");
});

pub fn main() void
{
    const screen_width = 800;
    const screen_height = 450;

    ray.InitWindow(screen_width, screen_height, "raylib [core] example - basic window");
    defer ray.CloseWindow(); // Close window and OpenGL context

    ray.SetTargetFPS(60); // Set our game to run at 60 frames-per-second

    while (!ray.WindowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        ray.BeginDrawing();
        defer ray.EndDrawing();

        ray.ClearBackground(ray.RAYWHITE);
        ray.DrawText("Congrats! You created your first window!", 190, 200, 20, ray.LIGHTGRAY);
        //----------------------------------------------------------------------------------
    }
}
