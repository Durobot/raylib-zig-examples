// build with `zig build-exe main.zig -lc -lraylib`

// This is a Zig version of a raylib example from
// https://github.com/raysan5/raylib/
// It is distributed under the same license as the original - unmodified zlib/libpng license
// Header from the original source code follows below:

///*******************************************************************************************
//*
//*   raylib [core] example - Mouse input
//*
//*   Example originally created with raylib 1.0, last time updated with raylib 4.0
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

    c.InitWindow(screen_width, screen_height, "raylib [core] example - mouse input");
    defer c.CloseWindow(); // Close window and OpenGL context

    c.SetTargetFPS(60);

    var ball_pos = c.Vector2{ .x = @as(f32, screen_width) / 2.0, .y = @as(f32, screen_height) / 2.0, };
    var ball_color: c.Color = c.DARKBLUE;
    while (!c.WindowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        ball_pos = c.GetMousePosition();

        if (c.IsMouseButtonPressed(c.MOUSE_BUTTON_LEFT))         { ball_color = c.MAROON; }
        else if (c.IsMouseButtonPressed(c.MOUSE_BUTTON_MIDDLE))  { ball_color = c.LIME; }
        else if (c.IsMouseButtonPressed(c.MOUSE_BUTTON_RIGHT))   { ball_color = c.DARKBLUE; }
        else if (c.IsMouseButtonPressed(c.MOUSE_BUTTON_SIDE))    { ball_color = c.PURPLE; }
        else if (c.IsMouseButtonPressed(c.MOUSE_BUTTON_EXTRA))   { ball_color = c.YELLOW; }
        else if (c.IsMouseButtonPressed(c.MOUSE_BUTTON_FORWARD)) { ball_color = c.ORANGE; }
        else if (c.IsMouseButtonPressed(c.MOUSE_BUTTON_BACK))    { ball_color = c.BEIGE; }
        //----------------------------------------------------------------------------------

        // Draw
        //---------------------------------------------------------------------------------
        c.BeginDrawing();
        defer c.EndDrawing();

        c.ClearBackground(c.RAYWHITE);
        c.DrawText("move the ball mouse, click to change color", 10, 10, 20, c.DARKGRAY);
        c.DrawCircleV(ball_pos, 50, ball_color);
        //---------------------------------------------------------------------------------
    }
}
