// build with `zig build-exe main.zig -lc -lraylib`

// This is a Zig version of a raylib example from
// https://github.com/raysan5/raylib/
// It is distributed under the same license as the original - unmodified zlib/libpng license
// Header from the original source code follows below:

///*******************************************************************************************
//*
//*   raylib [core] example - 2d camera mouse zoom
//*
//*   Example originally created with raylib 4.2, last time updated with raylib 4.2
//*
//*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//*   BSD-like license that allows static linking with closed source software
//*
//*   Copyright (c) 2022-2023 Jeffery Myers (@JeffM2501)
//*
//********************************************************************************************/

const std = @import("std"); // std.mem.zeroes()
const c = @cImport(
{
    @cInclude("raylib.h");
    @cInclude("rlgl.h");
    @cInclude("raymath.h");
});

pub fn main() void
{
    const screen_width = 800;
    const screen_height = 450;

    c.InitWindow(screen_width, screen_height, "raylib [core] example - 2d camera mouse zoom");
    defer c.CloseWindow();

    // Explicitly initializing struct fields is better,
    // but we can also do this:
    var camera = comptime std.mem.zeroes(c.Camera2D);
    camera.zoom = 1.0;

    c.SetTargetFPS(60);

    while (!c.WindowShouldClose())
    {
        // Update
        //----------------------------------------------------------------------------------
        // Translate based on mouse right click
        if (c.IsMouseButtonDown(c.MOUSE_BUTTON_RIGHT))
        {
            var delta = c.GetMouseDelta(); // Vector2
            delta = c.Vector2Scale(delta, -1.0 / camera.zoom);

            camera.target = c.Vector2Add(camera.target, delta);
        }

        // Zoom based on mouse wheel
        const wheel = c.GetMouseWheelMove();
        if (wheel != 0.0)
        {
            // Get the world point that is under the mouse
            const mouse_world_pos = c.GetScreenToWorld2D(c.GetMousePosition(), camera); // Vector2

            // Set the offset to where the mouse is
            camera.offset = c.GetMousePosition();

            // Set the target to match, so that the camera maps the world space point
            // under the cursor to the screen space point under the cursor at any zoom
            camera.target = mouse_world_pos;

            // Zoom increment
            const zoom_increment = 0.125;

            camera.zoom += (wheel * zoom_increment);
            if (camera.zoom < zoom_increment) camera.zoom = zoom_increment;
        }
        //----------------------------------------------------------------------------------

        // Draw
        //---------------------------------------------------------------------------------
        c.BeginDrawing();
        defer c.EndDrawing();

        c.ClearBackground(c.BLACK);

        {
            c.BeginMode2D(camera);
            defer c.EndMode2D();

            // Draw the 3d grid, rotated 90 degrees and centered around 0,0
            // just so we have something in the XY plane
            c.rlPushMatrix();
                c.rlTranslatef(0.0, 25.0*50.0, 0.0);
                c.rlRotatef(90.0, 1.0, 0.0, 0.0);
                c.DrawGrid(100, 50.0);
            c.rlPopMatrix();

            // Draw a reference circle
            c.DrawCircle(100, 100, 50, c.YELLOW);
        }

        c.DrawText("Mouse right button drag to move, mouse wheel to zoom", 10, 10, 20, c.WHITE);
        //---------------------------------------------------------------------------------
    }
}
