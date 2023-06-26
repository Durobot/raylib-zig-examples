// build with `zig build-exe main.zig -lc -lraylib`

// This is a Zig version of a raylib example from
// https://github.com/raysan5/raylib/
// It is distributed under the same license as the original - unmodified zlib/libpng license
// Header from the original source code follows below:

///*******************************************************************************************
//*
//*   raylib [core] example - 2d camera
//*
//*   Example originally created with raylib 1.5, last time updated with raylib 3.0
//*
//*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//*   BSD-like license that allows static linking with closed source software
//*
//*   Copyright (c) 2016-2023 Ramon Santamaria (@raysan5)
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
    const max_buildings = 100;

    c.InitWindow(screen_width, screen_height, "raylib [core] example - 2d camera");
    defer c.CloseWindow(); // Close window and OpenGL context

    var player = c.Rectangle{ .x = 400.0, .y = 280.0, .width = 40.0, .height = 40.0 };
    var buildings = [_]c.Rectangle{ .{ .x = 0.0, .y = 0.0, .width = 0.0, .height = 0.0 } } ** max_buildings;
    var build_colors = [_]c.Color{ .{ .r = 0, .g = 0, .b = 0, .a = 0 } } ** max_buildings;

    // comptime
    // error: comptime call of extern function
    //        buildings[i].width = @as(f32, c.GetRandomValue(50, 200));
    //                                      ~~~~~~~~~~~~~~~~^~~~~~~~~
    {
        var spacing: i32 = 0;
        for (0..max_buildings) |i|
        {
            buildings[i].width = @floatFromInt(f32, c.GetRandomValue(50, 200));
            buildings[i].height = @floatFromInt(f32, c.GetRandomValue(100, 800));

            buildings[i].y = screen_height - 130.0 - buildings[i].height;
            buildings[i].x = -6000.0 + @floatFromInt(f32, spacing);

            spacing += @intFromFloat(i32, buildings[i].width);

            build_colors[i] = c.Color
            {
                .r = @intCast(u8, c.GetRandomValue(200, 240)),
                .g = @intCast(u8, c.GetRandomValue(200, 240)),
                .b = @intCast(u8, c.GetRandomValue(200, 250)),
                .a = 255
            };
        }
    }

    var camera = c.Camera2D
    {
        .target = .{ .x = player.x + 20.0, .y = player.y + 20.0 }, // c.Vector2
        .offset = .{ .x = screen_width / 2.0, .y = screen_height / 2.0 }, // c.Vector2
        .rotation = 0.0,
        .zoom = 1.0,
    };

    c.SetTargetFPS(60);

    while (!c.WindowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        // Player movement
        if (c.IsKeyDown(c.KEY_RIGHT))
        { player.x += 2; }
        else
            if (c.IsKeyDown(c.KEY_LEFT))
                player.x -= 2;

        // Camera target follows player
        camera.target = .{ .x = player.x + 20.0, .y = player.y + 20.0 };

        // Camera rotation controls
        if (c.IsKeyDown(c.KEY_A))
        { camera.rotation -= 1.0; }
        else
            if (c.IsKeyDown(c.KEY_S))
                camera.rotation += 1.0;

        // Limit camera rotation to 80 degrees (-40 to 40)
        if (camera.rotation > 40)
        { camera.rotation = 40; }
        else
            if (camera.rotation < -40)
                camera.rotation = -40;

        // Camera zoom controls
        camera.zoom += c.GetMouseWheelMove() * 0.05;

        if (camera.zoom > 3.0)
        { camera.zoom = 3.0; }
        else
            if (camera.zoom < 0.1)
                camera.zoom = 0.1;

        // Camera reset (zoom and rotation)
        if (c.IsKeyPressed(c.KEY_R))
        {
            camera.zoom = 1.0;
            camera.rotation = 0.0;
        }
        //----------------------------------------------------------------------------------

        // Draw
        //---------------------------------------------------------------------------------
        {
            c.BeginDrawing();
            defer c.EndDrawing();

            c.ClearBackground(c.RAYWHITE);

            {
                c.BeginMode2D(camera);
                defer c.EndMode2D();

                c.DrawRectangle(-6000, 320, 13000, 8000, c.DARKGRAY);

                for (buildings, build_colors) |bldng, clr|
                    c.DrawRectangleRec(bldng, clr);

                // Player character box
                c.DrawRectangleRec(player, c.RED);

                c.DrawLine(@intFromFloat(c_int, camera.target.x), -screen_height*10,
                           @intFromFloat(c_int, camera.target.x), screen_height*10, c.GREEN);
                c.DrawLine(-screen_width*10, @intFromFloat(c_int, camera.target.y),
                           screen_width*10, @intFromFloat(c_int, camera.target.y), c.GREEN);
            }

            c.DrawText("SCREEN AREA", 640, 10, 20, c.RED);

            // Viewport outline
            c.DrawRectangle(0, 0, screen_width, 5, c.RED);
            c.DrawRectangle(0, 5, 5, screen_height - 10, c.RED);
            c.DrawRectangle(screen_width - 5, 5, 5, screen_height - 10, c.RED);
            c.DrawRectangle(0, screen_height - 5, screen_width, 5, c.RED);

            // Info pane
            c.DrawRectangle(10, 10, 250, 113, c.Fade(c.SKYBLUE, 0.5));
            c.DrawRectangleLines(10, 10, 250, 113, c.BLUE);

            c.DrawText("Free 2d camera controls:", 20, 20, 10, c.BLACK);
            c.DrawText("- Right/Left to move Offset", 40, 40, 10, c.DARKGRAY);
            c.DrawText("- Mouse Wheel to Zoom in-out", 40, 60, 10, c.DARKGRAY);
            c.DrawText("- A / S to Rotate", 40, 80, 10, c.DARKGRAY);
            c.DrawText("- R to reset Zoom and Rotation", 40, 100, 10, c.DARKGRAY);
        }
        //---------------------------------------------------------------------------------
    }
}
