// build with `zig build-exe main.zig -lc -lraylib`

// This is a Zig version of a raylib example from
// https://github.com/raysan5/raylib/
// It is distributed under the same license as the original - unmodified zlib/libpng license

// This version adds a second cube for you to pick.
// Camera controls are also different. Use A and D to rotate the camera around the cubes.
// For the version that sticks to the original C example, see version 14a.

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
    const mouse_wheel_speed = 1.0;
    const fovy_perspective = 45.0;
    const width_orthographic = 10.0;

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
    //const cam_radius_squared = 10.0 * 10.0;
    var cam_angle: f32 = 0.0;
    var cam_dist: f32 = 10.0;
    // Really init the camera
    UpdateCam(&camera, cam_angle, cam_dist);

    const cube_pos_arr = [_]c.Vector3
    {
        .{.x = 0.0, .y = 1.0, .z = 0.0},
        .{.x = 1.0, .y = 2.0, .z = -0.5},
    };
    const cube_size_arr = [_]c.Vector3{ .{.x = 2.0, .y = 2.0, .z = 2.0} } ** 2;

    var ray = c.Ray{ .position = .{ .x = 0.0, .y = 0.0, .z = 0.0 },
                     .direction = .{ .x = 0.0, .y = 0.0, .z = 0.0 } }; // Picking line ray
    // Mimicking the original C code's { 0 }, just as an example on how.
    // Explicit initialization of individual fields is better, even if more verbose.
    var collision = comptime std.mem.zeroes(c.RayCollision); // Ray collision hit info

    c.SetTargetFPS(60);

    var collision_box_idx: ?usize = null;
    while (!c.WindowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        // -- Toggle camera controls --
        // Switch camera projection
        if (c.IsKeyPressed(c.KEY_KP_5) or c.IsKeyPressed(c.KEY_P))
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

        const mouse_mov = c.GetMouseWheelMove();
        if (mouse_mov != 0.0)
        {
            cam_dist -= mouse_mov * mouse_wheel_speed;
            if (cam_dist <= 0.5)
                cam_dist = 0.5;
            UpdateCam(&camera, cam_angle, cam_dist);
        }

        if (c.IsKeyDown(c.KEY_D))
        {
            cam_angle += 1.0;
            if (cam_angle >= 360.0)
                cam_angle = 0.0;
            UpdateCam(&camera, cam_angle, cam_dist);
        }

        if (c.IsKeyDown(c.KEY_A))
        {
            cam_angle -= 1.0;
            if (cam_angle <= 0.0)
                cam_angle = 360.0 - cam_angle;
            UpdateCam(&camera, cam_angle, cam_dist);
        }

        if (c.IsMouseButtonPressed(c.MOUSE_BUTTON_LEFT))
        {
            ray = c.GetMouseRay(c.GetMousePosition(), camera);

            // Check collision between ray and boxes
            var min_hit_dist = std.math.floatMax(f32);
            collision_box_idx = null;
            for (cube_pos_arr, cube_size_arr, 0..) |cube_pos, cube_size, i|
            {
                collision = c.GetRayCollisionBox(ray,
                    .{ .min = .{ .x = cube_pos.x - cube_size.x/2.0, .y = cube_pos.y - cube_size.y/2.0, .z = cube_pos.z - cube_size.z/2.0 },
                       .max = .{ .x = cube_pos.x + cube_size.x/2.0, .y = cube_pos.y + cube_size.y/2.0, .z = cube_pos.z + cube_size.z/2.0 }});
                if (collision.hit and collision.distance < min_hit_dist)
                {
                    // New collision is closer to the camera than the previously found one
                    collision_box_idx = i;
                    min_hit_dist = collision.distance;
                }
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

            if (collision_box_idx) |box_idx| // (collision.hit)
            {
                for (cube_pos_arr, cube_size_arr, 0..) |cube_pos, cube_size, i|
                {
                    if (i == box_idx)
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
                }
            }
            else // collision_box_idx == null
                for (cube_pos_arr, cube_size_arr) |cube_pos, cube_size|
                {
                    c.DrawCube(cube_pos, cube_size.x, cube_size.y, cube_size.z, c.GRAY);
                    c.DrawCubeWires(cube_pos, cube_size.x, cube_size.y, cube_size.z, c.DARKGRAY);
                }

            //c.DrawRay(ray, c.MAROON);
            c.DrawGrid(10, 1.0);
        }

        c.DrawText("Click on a box", 280, 10, 20, c.DARKGRAY);
        if (collision_box_idx) |box_idx|
        {
            // https://github.com/raysan5/raylib/blob/9d38363e09aa8725415b444cde37a909d4d9d8a0/src/rtext.c
            // raylib's TextFormat stores formatted text in one of it's internal static buffers:
            // static char buffers[MAX_TEXTFORMAT_BUFFERS][MAX_TEXT_BUFFER_LENGTH] = { 0 };
            // It returns a pointer to one of its buffers. The buffers are reused in a circular manner.
            // Normally, #define MAX_TEXTFORMAT_BUFFERS 4
            // and       #define MAX_TEXT_BUFFER_LENGTH 1024
            const fmt_text = c.TextFormat("BOX %03i SELECTED", box_idx);
            c.DrawText(fmt_text,
                @divTrunc(screen_width - c.MeasureText(fmt_text, 30), 2),
                @intFromFloat(c_int, screen_height * 0.1), 30, c.GREEN);
        }

        c.DrawText("Press A or D to orbit the camera, mouse wheel to dolly, P or Numpad 5 to switch projection modes", 10, 430, 10, c.GRAY);
        c.DrawFPS(10, 10);
        //---------------------------------------------------------------------------------
    }
}

inline fn UpdateCam(cam: *c.Camera3D, cam_angle: f32, cam_dist: f32) void
{
    cam.position.x = cam_dist * @sin(cam_angle * std.math.pi / 180.0);
    cam.position.z = cam_dist * @cos(cam_angle * std.math.pi / 180.0);
}
