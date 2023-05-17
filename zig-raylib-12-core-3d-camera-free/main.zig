// build with `zig build-exe main.zig -lc -lraylib`

// This is a Zig version of a raylib example from
// https://github.com/raysan5/raylib/
// It is distributed under the same license as the original - unmodified zlib/libpng license
// Header from the original source code follows below:

///*******************************************************************************************
//*
//*   raylib [core] example - Initialize 3d camera free
//*
//*   Example originally created with raylib 1.3, last time updated with raylib 1.3
//*
//*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//*   BSD-like license that allows static linking with closed source software
//*
//*   Copyright (c) 2015-2023 Ramon Santamaria (@raysan5)
//*
//********************************************************************************************/

const c = @cImport(
{
    @cInclude("raylib.h");
});

pub fn main() void
{
    const screenWidth = 800;
    const screenHeight = 450;

    c.InitWindow(screenWidth, screenHeight, "raylib [core] example - 3d camera free");
    defer c.CloseWindow(); // Close window and OpenGL context

    // Define the camera to look into our 3d world
    var camera = c.Camera3D
    {
        .position = .{ .x = 10.0, .y = 10.0, .z = 10.0 }, // Camera position
        .target = .{ .x = 0.0, .y = 0.0, .z = 0.0 },      // Camera looking at point
        .up = .{ .x = 0.0, .y = 1.0, .z = 0.0 },          // Camera up vector (rotation towards target)
        .fovy = 45.0,                                     // Camera field-of-view Y
        .projection = c.CAMERA_PERSPECTIVE                // Camera mode type
    };
    const cube_pos = c.Vector3{ .x = 0.0, .y = 0.0, .z = 0.0 };

    c.DisableCursor(); // Limit cursor to relative movement inside the window
    c.SetTargetFPS(60);

    while (!c.WindowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        c.UpdateCamera(&camera, c.CAMERA_FREE);

        if (c.IsKeyDown('Z')) camera.target = .{ .x = 0.0, .y = 0.0, .z = 0.0 };
        //----------------------------------------------------------------------------------

        // Draw
        //---------------------------------------------------------------------------------
        c.BeginDrawing();
        defer c.EndDrawing();

        c.ClearBackground(c.RAYWHITE);
        {
            c.BeginMode3D(camera);
            defer c.EndMode3D();

            c.DrawCube(cube_pos, 2.0, 2.0, 2.0, c.RED);
            c.DrawCubeWires(cube_pos, 2.0, 2.0, 2.0, c.MAROON);
            c.DrawGrid(10, 1.0);
        }
        c.DrawRectangle(10, 10, 320, 133, c.Fade(c.SKYBLUE, 0.5));
        c.DrawRectangleLines(10, 10, 320, 133, c.BLUE);

        c.DrawText("Free camera default controls:", 20, 20, 10, c.BLACK);
        c.DrawText("- Mouse Wheel to Zoom in-out", 40, 40, 10, c.DARKGRAY);
        c.DrawText("- Mouse Wheel Pressed to Pan", 40, 60, 10, c.DARKGRAY);
        c.DrawText("- Alt + Mouse Wheel Pressed to Rotate", 40, 80, 10, c.DARKGRAY);
        c.DrawText("- Alt + Ctrl + Mouse Wheel Pressed for Smooth Zoom", 40, 100, 10, c.DARKGRAY);
        c.DrawText("- Z to zoom to (0, 0, 0)", 40, 120, 10, c.DARKGRAY);
        //---------------------------------------------------------------------------------
    }
}
