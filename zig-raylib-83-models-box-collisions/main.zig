// build with `zig build-exe main.zig -lc -lraylib`

// This is a Zig version of a raylib example from
// https://github.com/raysan5/raylib/
// It is distributed under the same license as the original - unmodified zlib/libpng license
// Header from the original source code follows below:

///*******************************************************************************************
//*
//*   raylib [models] example - Detect basic 3d collisions (box vs sphere vs box)
//*
//*   Example originally created with raylib 1.3, last time updated with raylib 3.5
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
    const screen_width = 800;
    const screen_height = 450;

    c.InitWindow(screen_width, screen_height, "raylib [models] example - box collisions");
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
    var player_pos = c.Vector3{ .x = 0.0, .y = 1.0, .z = 2.0 };
    const player_size = c.Vector3{ .x = 1.0, .y = 2.0, .z = 1.0 };
    var player_clr = c.GREEN; // c.Color

    const enemy_box_pos = c.Vector3{ .x = -4.0, .y = 1.0, .z = 0.0 };
    const enemy_box_size = c.Vector3{ .x = 2.0, .y = 2.0, .z = 2.0 };

    const enemy_sphere_pos = c.Vector3{ .x = 4.0, .y = 0.0, .z = 0.0 };
    const enemy_sphere_size = 1.5;

    var collision = false;

    c.SetTargetFPS(60);

    while (!c.WindowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        // Move player
        if (c.IsKeyDown(c.KEY_RIGHT))
        {   player_pos.x += 0.2;   }
        else
        {
            if (c.IsKeyDown(c.KEY_LEFT))
            {   player_pos.x -= 0.2;   }
            else
            {
                if (c.IsKeyDown(c.KEY_DOWN))
                {   player_pos.z += 0.2;   }
                else
                {
                    if (c.IsKeyDown(c.KEY_UP))
                        player_pos.z -= 0.2;
                }
            }
        }

        collision = false;

        // Check collisions player vs enemy-box
        if (c.CheckCollisionBoxes(
            .{ .min = .{ .x = player_pos.x - player_size.x/2.0,
                         .y = player_pos.y - player_size.y/2.0,
                         .z = player_pos.z - player_size.z/2.0 },
               .max = .{ .x = player_pos.x + player_size.x/2.0,
                         .y = player_pos.y + player_size.y/2.0,
                         .z = player_pos.z + player_size.z/2.0 }},
            .{ .min = .{ .x = enemy_box_pos.x - enemy_box_size.x/2.0,
                         .y = enemy_box_pos.y - enemy_box_size.y/2.0,
                         .z = enemy_box_pos.z - enemy_box_size.z/2.0 },
               .max = .{ .x = enemy_box_pos.x + enemy_box_size.x/2.0,
                         .y = enemy_box_pos.y + enemy_box_size.y/2.0,
                         .z = enemy_box_pos.z + enemy_box_size.z/2.0 }}))
            collision = true;

        // Check collisions player vs enemy-sphere
        if (c.CheckCollisionBoxSphere(
            .{ .min = .{ .x = player_pos.x - player_size.x/2.0,
                         .y = player_pos.y - player_size.y/2.0,
                         .z = player_pos.z - player_size.z/2.0 },
               .max = .{ .x = player_pos.x + player_size.x/2.0,
                         .y = player_pos.y + player_size.y/2.0,
                         .z = player_pos.z + player_size.z/2.0 }},
            enemy_sphere_pos, enemy_sphere_size))
            collision = true;

        if (collision)
        {   player_clr = c.RED;   }
        else
            player_clr = c.GREEN;
        //----------------------------------------------------------------------------------

        // Draw
        //---------------------------------------------------------------------------------
        c.BeginDrawing();
        defer c.EndDrawing();

        c.ClearBackground(c.RAYWHITE);
        {
            c.BeginMode3D(camera);
            defer c.EndMode3D();

            // Draw enemy-box
            c.DrawCube(enemy_box_pos, enemy_box_size.x, enemy_box_size.y, enemy_box_size.z, c.GRAY);
            c.DrawCubeWires(enemy_box_pos, enemy_box_size.x, enemy_box_size.y, enemy_box_size.z, c.DARKGRAY);

            // Draw enemy-sphere
            c.DrawSphere(enemy_sphere_pos, enemy_sphere_size, c.GRAY);
            c.DrawSphereWires(enemy_sphere_pos, enemy_sphere_size, 16, 16, c.DARKGRAY);

            // Draw player
            c.DrawCubeV(player_pos, player_size, player_clr);

            c.DrawGrid(10, 1.0); // Draw a grid
        }
        c.DrawText("Move player with cursors to collide", 220, 40, 20, c.GRAY);
        c.DrawFPS(10, 10);
        //---------------------------------------------------------------------------------
    }
}
