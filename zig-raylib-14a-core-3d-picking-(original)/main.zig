// build with `zig build-exe main.zig -lc -lraylib`

// This is a Zig version of a raylib example from
// https://github.com/raysan5/raylib/
// It is distributed under the same license as the original - unmodified zlib/libpng license

// This version sticks to the original C example.
// For the version with two cubes, see version 14b.

// Header from the original source code follows below:

///*******************************************************************************************
//*
//*   raylib [core] example - Picking in 3d mode
//*
//*   Example originally created with raylib 1.3, last time updated with raylib 4.0
//*
//*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//*   BSD-like license that allows static linking with closed source software
//*
//*   Copyright (c) 2015-2023 Ramon Santamaria (@raysan5)
//*
//********************************************************************************************/

const std = @import("std"); // std.mem.zeroes()
const c = @cImport(
{
    @cInclude("raylib.h");
});

pub fn main() void
{
    const screen_width = 800;
    const screen_height = 450;

    c.InitWindow(screen_width, screen_height, "raylib [core] example - 3d picking");
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
    const cube_pos = c.Vector3{ .x = 0.0, .y = 1.0, .z = 0.0 };
    const cube_size = c.Vector3{ .x = 2.0, .y = 2.0, .z = 2.0 };

    var ray = c.Ray{ .position = .{ .x = 0.0, .y = 0.0, .z = 0.0 },
                     .direction = .{ .x = 0.0, .y = 0.0, .z = 0.0 } }; // Picking line ray
    var collision = comptime std.mem.zeroes(c.RayCollision);     // Ray collision hit info

    c.SetTargetFPS(60);

    while (!c.WindowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        if (c.IsCursorHidden()) c.UpdateCamera(&camera, c.CAMERA_FIRST_PERSON);

        // Toggle camera controls
        if (c.IsMouseButtonPressed(c.MOUSE_BUTTON_RIGHT))
        {
            if (c.IsCursorHidden()) { c.EnableCursor(); }
            else c.DisableCursor();
        }

        if (c.IsMouseButtonPressed(c.MOUSE_BUTTON_LEFT))
        {
            if (!collision.hit)
            {
                ray = c.GetMouseRay(c.GetMousePosition(), camera);

                // Check collision between ray and box
                collision = c.GetRayCollisionBox(ray,
                    .{ .min = .{ .x = cube_pos.x - cube_size.x/2, .y = cube_pos.y - cube_size.y/2, .z = cube_pos.z - cube_size.z/2 },
                       .max = .{ .x = cube_pos.x + cube_size.x/2, .y = cube_pos.y + cube_size.y/2, .z = cube_pos.z + cube_size.z/2 }});
            }
            else collision.hit = false;
        }
        //----------------------------------------------------------------------------------

        // Draw
        //---------------------------------------------------------------------------------
        c.BeginDrawing();
        defer c.EndDrawing();

        c.ClearBackground(c.RAYWHITE);
        {
            c.BeginMode3D(camera);
            defer c.EndMode3D();

            if (collision.hit)
            {
                c.DrawCube(cube_pos, cube_size.x, cube_size.y, cube_size.z, c.RED);
                c.DrawCubeWires(cube_pos, cube_size.x, cube_size.y, cube_size.z, c.MAROON);

                c.DrawCubeWires(cube_pos, cube_size.x + 0.2, cube_size.y + 0.2, cube_size.z + 0.2, c.GREEN);
            }
            else
            {
                c.DrawCube(cube_pos, cube_size.x, cube_size.y, cube_size.z, c.GRAY);
                c.DrawCubeWires(cube_pos, cube_size.x, cube_size.y, cube_size.z, c.DARKGRAY);
            }

            c.DrawRay(ray, c.MAROON);
            c.DrawGrid(10, 1.0);
        }
        c.DrawText("Try clicking on the box with your mouse!", 240, 10, 20, c.DARKGRAY);
        if (collision.hit)
            c.DrawText("BOX SELECTED",
                       @divTrunc(screen_width - c.MeasureText("BOX SELECTED", 30), 2),
                       @intFromFloat(c_int, screen_height * 0.1), 30, c.GREEN);
        c.DrawText("Right click mouse to toggle camera controls", 10, 430, 10, c.GRAY);
        c.DrawFPS(10, 10);
        //---------------------------------------------------------------------------------
    }
}
