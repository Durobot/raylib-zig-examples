// build with `zig build-exe main.zig -lc -lraylib`

// This is a Zig version of a raylib example from
// https://github.com/raysan5/raylib/
// It is distributed under the same license as the original - unmodified zlib/libpng license
// Header from the original source code follows below:

///*******************************************************************************************
//*
//*   raylib [shapes] example - Cubic-bezier lines
//*
//*   Example originally created with raylib 1.7, last time updated with raylib 1.7
//*
//*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//*   BSD-like license that allows static linking with closed source software
//*
//*   Copyright (c) 2017-2023 Ramon Santamaria (@raysan5)
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

    c.SetConfigFlags(c.FLAG_MSAA_4X_HINT);
    c.InitWindow(screen_width, screen_height, "raylib [shapes] example - cubic-bezier lines");
    defer c.CloseWindow(); // Close window and OpenGL context

    var start = c.Vector2{ .x = 0.0, .y = 0.0 };
    var end = c.Vector2{ .x = screen_width, .y = screen_height };

    c.SetTargetFPS(60);

    while (!c.WindowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        if (c.IsMouseButtonDown(c.MOUSE_BUTTON_LEFT)) { start = c.GetMousePosition(); }
        else if (c.IsMouseButtonDown(c.MOUSE_BUTTON_RIGHT)) end = c.GetMousePosition();
        //----------------------------------------------------------------------------------

        // Draw
        //---------------------------------------------------------------------------------
        c.BeginDrawing();
        defer c.EndDrawing();

        c.ClearBackground(c.RAYWHITE);

        c.DrawText("USE MOUSE LEFT-RIGHT CLICK to DEFINE LINE START and END POINTS", 15, 20, 20, c.GRAY);
        c.DrawLineBezier(start, end, 2.0, c.RED);
        //---------------------------------------------------------------------------------
    }
}
