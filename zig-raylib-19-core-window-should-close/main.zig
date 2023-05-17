// build with `zig build-exe main.zig -lc -lraylib`

// This is a Zig version of a raylib example from
// https://github.com/raysan5/raylib/
// It is distributed under the same license as the original - unmodified zlib/libpng license
// Header from the original source code follows below:

///*******************************************************************************************
//*
//*   raylib [core] example - Window should close
//*
//*   Example originally created with raylib 4.2, last time updated with raylib 4.2
//*
//*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//*   BSD-like license that allows static linking with closed source software
//*
//*   Copyright (c) 2013-2023 Ramon Santamaria (@raysan5)
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

    c.InitWindow(screen_width, screen_height, "raylib [core] example - window should close");
    defer c.CloseWindow(); // Close window and OpenGL context

    c.SetExitKey(c.KEY_NULL); // Disable KEY_ESCAPE to close window, X-button still works

    var exit_window_requested = false; // Flag to request window to exit
    var exit_window = false; // Flag to set window to exit

    c.SetTargetFPS(60); // Set our game to run at 60 frames-per-second

    while (!exit_window)
    {
        // Update
        //----------------------------------------------------------------------------------
        // Detect if X-button or KEY_ESCAPE have been pressed to close window
        if (c.WindowShouldClose() or c.IsKeyPressed(c.KEY_ESCAPE)) exit_window_requested = true;

        if (exit_window_requested)
        {
            // A request for close window has been issued, we can save data before closing
            // or just show a message asking for confirmation

            if (c.IsKeyPressed(c.KEY_Y)) { exit_window = true; }
            else if (c.IsKeyPressed(c.KEY_N)) exit_window_requested = false;
        }
        //----------------------------------------------------------------------------------

        // Draw
        //---------------------------------------------------------------------------------
        c.BeginDrawing();
        defer c.EndDrawing();

        c.ClearBackground(c.RAYWHITE);

        if (exit_window_requested)
        {
            c.DrawRectangle(0, 100, screen_width, 200, c.BLACK);
            c.DrawText("Are you sure you want to exit program? [Y/N]", 40, 180, 30, c.WHITE);
        }
        else
            c.DrawText("Try to close the window to get confirmation message!", 120, 200, 20, c.LIGHTGRAY);
        //---------------------------------------------------------------------------------
    }
}
