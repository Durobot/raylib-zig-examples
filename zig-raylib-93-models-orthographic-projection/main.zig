// build with `zig build-exe main.zig -lc -lraylib`

// This is a Zig version of a raylib example from
// https://github.com/raysan5/raylib/
// It is distributed under the same license as the original - unmodified zlib/libpng license
// Header from the original source code follows below:

///*******************************************************************************************
//*
//*   raylib [models] example - Show the difference between perspective and orthographic projection
//*
//*   Example originally created with raylib 2.0, last time updated with raylib 3.7
//*
//*   Example contributed by Max Danielsson (@autious) and reviewed by Ramon Santamaria (@raysan5)
//*
//*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//*   BSD-like license that allows static linking with closed source software
//*
//*   Copyright (c) 2018-2023 Max Danielsson (@autious) and Ramon Santamaria (@raysan5)
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
    const fovy_perspective = 45.0;
    const width_orthographic = 10.0;

    c.InitWindow(screen_width, screen_height, "raylib [models] example - orthographic projection");
    defer c.CloseWindow(); // Close window and OpenGL context

    // Define the camera to look into our 3d world
    var camera = c.Camera3D
    {
        .position = .{ .x = 0.0, .y = 10.0, .z = 10.0 }, // Camera position
        .target = .{ .x = 0.0, .y = 0.0, .z = 0.0 },     // Camera looking at point
        .up = .{ .x = 0.0, .y = 1.0, .z = 0.0 },         // Camera up vector (rotation towards target)
        .fovy = fovy_perspective,                        // Camera field-of-view Y
        .projection = c.CAMERA_PERSPECTIVE               // Camera mode type
    };

    c.SetTargetFPS(60);

    while (!c.WindowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        if (c.IsKeyPressed(c.KEY_SPACE))
        {
            if (camera.projection == c.CAMERA_PERSPECTIVE)
            {
                camera.fovy = width_orthographic;
                camera.projection = c.CAMERA_ORTHOGRAPHIC;
            }
            else
            {
                camera.fovy = fovy_perspective;
                camera.projection = c.CAMERA_PERSPECTIVE;
            }
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

            c.DrawCube(.{.x = -4.0, .y = 0.0, .z = 2.0}, 2.0, 5.0, 2.0, c.RED);
            c.DrawCubeWires(.{.x = -4.0, .y = 0.0, .z = 2.0}, 2.0, 5.0, 2.0, c.GOLD);
            c.DrawCubeWires(.{.x = -4.0, .y = 0.0, .z = -2.0}, 3.0, 6.0, 2.0, c.MAROON);

            c.DrawSphere(.{.x = -1.0, .y = 0.0, .z = -2.0}, 1.0, c.GREEN);
            c.DrawSphereWires(.{.x = 1.0, .y = 0.0, .z = 2.0}, 2.0, 16, 16, c.LIME);

            c.DrawCylinder(.{.x = 4.0, .y = 0.0, .z = -2.0}, 1.0, 2.0, 3.0, 4, c.SKYBLUE);
            c.DrawCylinderWires(.{.x = 4.0, .y = 0.0, .z = -2.0}, 1.0, 2.0, 3.0, 4, c.DARKBLUE);
            c.DrawCylinderWires(.{.x = 4.5, .y = -1.0, .z = 2.0}, 1.0, 1.0, 2.0, 6, c.BROWN);

            c.DrawCylinder(.{.x = 1.0, .y = 0.0, .z = -4.0}, 0.0, 1.5, 3.0, 8, c.GOLD);
            c.DrawCylinderWires(.{.x = 1.0, .y = 0.0, .z = -4.0}, 0.0, 1.5, 3.0, 8, c.PINK);

            c.DrawCapsule     (.{.x = -3.0, .y = 1.5, .z = -4.0}, .{.x = -4.0, .y = -1.0, .z = -4.0}, 1.2, 8, 8, c.VIOLET);
            c.DrawCapsuleWires(.{.x = -3.0, .y = 1.5, .z = -4.0}, .{.x = -4.0, .y = -1.0, .z = -4.0}, 1.2, 8, 8, c.PURPLE);

            c.DrawGrid(10, 1.0); // Draw a grid
        }

        c.DrawText("Press Spacebar to switch camera type", 10, c.GetScreenHeight() - 30, 20, c.DARKGRAY);

        if (camera.projection == c.CAMERA_ORTHOGRAPHIC)
        {   c.DrawText("ORTHOGRAPHIC", 10, 40, 20, c.BLACK);   }
        else
            if (camera.projection == c.CAMERA_PERSPECTIVE)
                c.DrawText("PERSPECTIVE", 10, 40, 20, c.BLACK);

        c.DrawFPS(10, 10);
        //---------------------------------------------------------------------------------
    }
}
