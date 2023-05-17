// build with `zig build-exe main.zig -lc -lraylib`

// This is a Zig version of a raylib example from
// https://github.com/raysan5/raylib/
// It is distributed under the same license as the original - unmodified zlib/libpng license
// Header from the original source code follows below:

///*******************************************************************************************
//*
//*   raylib [core] example - Initialize 3d camera mode
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

    c.InitWindow(screen_width, screen_height, "raylib [core] example - 3d camera mode");
    defer c.CloseWindow(); // Close window and OpenGL context

    // Define the camera to look into our 3d world
    const camera = c.Camera3D
    {
        .position = .{ .x = 0.0, .y = 10.0, .z = 10.0 }, // Camera position
        .target = .{ .x = 0.0, .y = 0.0, .z = 0.0 },     // Camera looking at point
        .up = .{ .x = 0.0, .y = 1.0, .z = 0.0 },         // Camera up vector (rotation towards target)
        .fovy = 45.0,                                    // Camera field-of-view Y
        .projection = c.CAMERA_PERSPECTIVE               // Camera mode type
    };
    const cube_pos = c.Vector3{ .x = 0.0, .y = 0.0, .z = 0.0 };

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
        {
            c.BeginMode3D(camera);
            defer c.EndMode3D();

            c.DrawCube(cube_pos, 2.0, 2.0, 2.0, c.RED);
            c.DrawCubeWires(cube_pos, 2.0, 2.0, 2.0, c.MAROON);
            c.DrawGrid(10, 1.0);
        }
        c.DrawText("Welcome to the third dimension!", 10, 40, 20, c.DARKGRAY);
        c.DrawFPS(10, 10);
        //---------------------------------------------------------------------------------
    }
}
