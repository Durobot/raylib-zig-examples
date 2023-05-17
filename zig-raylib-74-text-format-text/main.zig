// build with `zig build-exe main.zig -lc -lraylib`

// This is a Zig version of a raylib example from
// https://github.com/raysan5/raylib/
// It is distributed under the same license as the original - unmodified zlib/libpng license
// Header from the original source code follows below:

///*******************************************************************************************
//*
//*   raylib [text] example - Text formatting
//*
//*   Example originally created with raylib 1.1, last time updated with raylib 3.0
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

    c.InitWindow(screen_width, screen_height, "raylib [text] example - text formatting");
    defer c.CloseWindow(); // Close window and OpenGL context

    const score = 100020;
    const hiscore = 200450;
    const lives = 5;

    c.SetTargetFPS(60);

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

        // error: integer and float literals passed variadic function must be casted to a fixed-size number type
        c.DrawText(c.TextFormat("Score: %08i", @as(c_int, score)), 200, 80, 20, c.RED);
        c.DrawText(c.TextFormat("HiScore: %08i", @as(c_int, hiscore)), 200, 120, 20, c.GREEN);
        c.DrawText(c.TextFormat("Lives: %02i", @as(c_int, lives)), 200, 160, 40, c.BLUE);
        c.DrawText(c.TextFormat("Elapsed Time: %02.02f ms", c.GetFrameTime()*1000), 200, 220, 20, c.BLACK);
        //---------------------------------------------------------------------------------
    }
}
