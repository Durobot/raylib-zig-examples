// build with `zig build-exe main.zig -lc -lraylib`

// This is a Zig version of a raylib example from
// https://github.com/raysan5/raylib/
// It is distributed under the same license as the original - unmodified zlib/libpng license
// Header from the original source code follows below:

///*******************************************************************************************
//*
//*   raylib [core] examples - Mouse wheel input
//*
//*   Example originally created with raylib 1.1, last time updated with raylib 1.3
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
    const scroll_speed = 4;

    c.InitWindow(screen_width, screen_height, "raylib [core] example - input mouse wheel");
    defer c.CloseWindow(); // Close window and OpenGL context

    c.SetTargetFPS(60);

    var ball_pos_y: c_int = screen_height / 2 - 40;
    while (!c.WindowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        // @round() is optional, i guess?
        // Since scroll_speed is an integer constant, there's no sense in coercing it to f32,
        // multiplying GetMouseWheelMove()'s result (f32) by it and then coercing the result
        // back to integer (c_int).
        ball_pos_y -= @intFromFloat(c_int, @round(c.GetMouseWheelMove())) * scroll_speed;
        //----------------------------------------------------------------------------------

        // Draw
        //---------------------------------------------------------------------------------
        c.BeginDrawing();
        defer c.EndDrawing();

        c.ClearBackground(c.RAYWHITE);

        c.DrawRectangle(screen_width / 2 - 40, ball_pos_y, 80, 80, c.MAROON);
        c.DrawText("Use mouse wheel to move the cube up and down!", 10, 10, 20, c.GRAY);
        c.DrawText(c.TextFormat("Box position Y: %03i", ball_pos_y), 10, 40, 20, c.LIGHTGRAY);
        //---------------------------------------------------------------------------------
    }
}
