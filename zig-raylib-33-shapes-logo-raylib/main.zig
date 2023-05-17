// build with `zig build-exe main.zig -lc -lraylib`

// This is a Zig version of a raylib example from
// https://github.com/raysan5/raylib/
// It is distributed under the same license as the original - unmodified zlib/libpng license
// Header from the original source code follows below:

///*******************************************************************************************
//*
//*   raylib [shapes] example - Draw raylib logo using basic shapes
//*
//*   Example originally created with raylib 1.0, last time updated with raylib 1.0
//*
//*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//*   BSD-like license that allows static linking with closed source software
//*
//*   Copyright (c) 2014-2023 Ramon Santamaria (@raysan5)
//*
//********************************************************************************************/

const c = @cImport(
{
    @cInclude("raylib.h");
});

pub fn main() void
{
    const screen_width = 800;
    const screen_height = 450;

    c.InitWindow(screen_width, screen_height, "raylib [shapes] example - raylib logo using shapes");
    defer c.CloseWindow(); // Close window and OpenGL context

    c.SetTargetFPS(60); // Set our game to run at 60 frames-per-second

    while (!c.WindowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        //----------------------------------------------------------------------------------

        // Draw
        //---------------------------------------------------------------------------------
        c.BeginDrawing();
        defer c.EndDrawing();

        c.ClearBackground(c.RAYWHITE);

        c.DrawRectangle(screen_width/2 - 128, screen_height/2 - 128, 256, 256, c.BLACK);
        c.DrawRectangle(screen_width/2 - 112, screen_height/2 - 112, 224, 224, c.RAYWHITE);
        c.DrawText("raylib", screen_width/2 - 44, screen_height/2 + 48, 50, c.BLACK);

        c.DrawText("this is NOT a texture!", 350, 370, 10, c.GRAY);
        //---------------------------------------------------------------------------------
    }
}
