// build with `zig build-exe main.zig -lc -lraylib`

// This is a Zig version of a raylib example from
// https://github.com/raysan5/raylib/
// It is distributed under the same license as the original - unmodified zlib/libpng license
// Header from the original source code follows below:

///*******************************************************************************************
//*
//*   raylib [shapes] example - following eyes
//*
//*   Example originally created with raylib 2.5, last time updated with raylib 2.5
//*
//*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//*   BSD-like license that allows static linking with closed source software
//*
//*   Copyright (c) 2013-2023 Ramon Santamaria (@raysan5)
//*
//********************************************************************************************/

const std = @import("std"); // fn std.math.atan2()
const c = @cImport(
{
    @cInclude("raylib.h");
});

pub fn main() void
{
    const screen_width = 800;
    const screen_height = 450;

    c.InitWindow(screen_width, screen_height, "raylib [shapes] example - following eyes");
    defer c.CloseWindow(); // Close window and OpenGL context

    const sclera_left_pos = c.Vector2{ .x = @floatFromInt(f32, c.GetScreenWidth()) / 2.0 - 100.0,
                                       .y = @floatFromInt(f32, c.GetScreenHeight()) / 2.0 };
    const sclera_right_pos = c.Vector2{ .x = @floatFromInt(f32, c.GetScreenWidth()) / 2.0 + 100.0,
                                        .y = @floatFromInt(f32, c.GetScreenHeight()) / 2.0 };
    const sclera_radius = 80.0;

    var iris_left_pos = c.Vector2{ .x = @floatFromInt(f32, c.GetScreenWidth()) / 2.0 - 100.0,
                                   .y = @floatFromInt(f32, c.GetScreenHeight()) / 2.0 };
    var iris_right_pos = c.Vector2{ .x = @floatFromInt(f32, c.GetScreenWidth()) / 2.0 + 100.0,
                                    .y = @floatFromInt(f32, c.GetScreenHeight()) / 2.0 };
    const iris_radius = 24.0;

    var angle: f32 = 0.0;
    var dx: f32 = 0.0;
    var dy: f32 = 0.0;
    var dxx: f32 = 0.0;
    var dyy: f32 = 0.0;

    c.SetTargetFPS(60);

    while (!c.WindowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        iris_left_pos = c.GetMousePosition();
        iris_right_pos = c.GetMousePosition();

        // Check not inside the left eye sclera
        if (!c.CheckCollisionPointCircle(iris_left_pos, sclera_left_pos, sclera_radius - 20))
        {
            dx = iris_left_pos.x - sclera_left_pos.x;
            dy = iris_left_pos.y - sclera_left_pos.y;

            angle = std.math.atan2(f32, dy, dx);

            dxx = (sclera_radius - iris_radius) * @cos(angle);
            dyy = (sclera_radius - iris_radius) * @sin(angle);

            iris_left_pos.x = sclera_left_pos.x + dxx;
            iris_left_pos.y = sclera_left_pos.y + dyy;
        }

        // Check not inside the right eye sclera
        if (!c.CheckCollisionPointCircle(iris_right_pos, sclera_right_pos, sclera_radius - 20))
        {
            dx = iris_right_pos.x - sclera_right_pos.x;
            dy = iris_right_pos.y - sclera_right_pos.y;

            angle = std.math.atan2(f32, dy, dx);

            dxx = (sclera_radius - iris_radius) * @cos(angle);
            dyy = (sclera_radius - iris_radius) * @sin(angle);

            iris_right_pos.x = sclera_right_pos.x + dxx;
            iris_right_pos.y = sclera_right_pos.y + dyy;
        }
        //----------------------------------------------------------------------------------

        // Draw
        //---------------------------------------------------------------------------------
        c.BeginDrawing();
        defer c.EndDrawing();

        c.ClearBackground(c.RAYWHITE);

        c.DrawCircleV(sclera_left_pos, sclera_radius, c.LIGHTGRAY);
        c.DrawCircleV(iris_left_pos, iris_radius, c.BROWN);
        c.DrawCircleV(iris_left_pos, 10, c.BLACK);

        c.DrawCircleV(sclera_right_pos, sclera_radius, c.LIGHTGRAY);
        c.DrawCircleV(iris_right_pos, iris_radius, c.DARKGREEN);
        c.DrawCircleV(iris_right_pos, 10, c.BLACK);

        c.DrawFPS(10, 10);
        //---------------------------------------------------------------------------------
    }
}
