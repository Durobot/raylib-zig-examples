// build with `zig build-exe main.zig -lc -lraylib`

// This is a Zig version of a raylib example from
// https://github.com/raysan5/raylib/
// It is distributed under the same license as the original - unmodified zlib/libpng license
// Header from the original source code follows below:

///*******************************************************************************************
//*
//*   raylib [core] example - Keyboard input
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

    c.InitWindow(screen_width, screen_height, "raylib [core] example - keyboard input");
    defer c.CloseWindow(); // Close window and OpenGL context

    c.SetTargetFPS(60);

    var ball_pos = c.Vector2{ .x = @as(f32, screen_width) / 2.0, .y = @as(f32, screen_height) / 2.0, };
    while (!c.WindowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        if (c.IsKeyDown(c.KEY_RIGHT)) ball_pos.x += 2.0;
        if (c.IsKeyDown(c.KEY_LEFT))  ball_pos.x -= 2.0;
        if (c.IsKeyDown(c.KEY_UP))    ball_pos.y -= 2.0;
        if (c.IsKeyDown(c.KEY_DOWN))  ball_pos.y += 2.0;
        //----------------------------------------------------------------------------------

        // Draw
        //---------------------------------------------------------------------------------
        c.BeginDrawing();
        defer c.EndDrawing();

        c.ClearBackground(c.RAYWHITE);
        c.DrawText("move the ball with arrow keys", 10, 10, 20, c.DARKGRAY);
        c.DrawCircleV(ball_pos, 50, c.MAROON);
        //---------------------------------------------------------------------------------
    }
}
