// build with `zig build-exe main.zig -lc -lraylib`

// This is a Zig version of a raylib example from
// https://github.com/raysan5/raylib/
// It is distributed under the same license as the original - unmodified zlib/libpng license
// Header from the original source code follows below:

///*******************************************************************************************
//*
//*   raylib [shapes] example - collision area
//*
//*   Example originally created with raylib 2.5, last time updated with raylib 2.5
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

    c.InitWindow(screen_width, screen_height, "raylib [shapes] example - collision area");
    defer c.CloseWindow(); // Close window and OpenGL context

    // Box A: Moving box
    var box_a = c.Rectangle{ .x = 10.0, .y = @floatFromInt(f32, c.GetScreenHeight()) / 2.0 - 50.0, .width = 200.0, .height = 100.0 };
    var box_a_speed_x: i32 = 4;

    // Box B: Mouse moved box
    var box_b = c.Rectangle{ .x = @floatFromInt(f32, c.GetScreenWidth()) / 2.0 - 30.0, .y = @floatFromInt(f32, c.GetScreenHeight()) / 2.0 - 30.0, .width = 60.0, .height = 60.0 };

    var box_collision = c.Rectangle{ .x = 0.0, .y = 0.0, .width = 0.0, .height = 0.0 }; // Collision rectangle

    const screen_upper_limit = 40; // Top menu limits

    var pause = false;             // Movement pause
    var collision = false;         // Collision detection

    c.SetTargetFPS(60);

    while (!c.WindowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        // Move box if not paused
        if (!pause)
            box_a.x += @floatFromInt(f32, box_a_speed_x);

        // Bounce box on x screen limits
        if (((box_a.x + box_a.width) >= @floatFromInt(f32, c.GetScreenWidth())) or (box_a.x <= 0.0))
            box_a_speed_x = -box_a_speed_x;

        // Update player-controlled-box (box02)
        box_b.x = @floatFromInt(f32, c.GetMouseX()) - box_b.width / 2.0;
        box_b.y = @floatFromInt(f32, c.GetMouseY()) - box_b.height / 2.0;

        // Make sure Box B does not go out of move area limits
        if ((box_b.x + box_b.width) >= @floatFromInt(f32, c.GetScreenWidth()))
        {   box_b.x = @floatFromInt(f32, c.GetScreenWidth()) - box_b.width;   }
        else
            if (box_b.x <= 0.0)
                box_b.x = 0.0;

        if ((box_b.y + box_b.height) >= @floatFromInt(f32, c.GetScreenHeight()))
        {   box_b.y = @floatFromInt(f32, c.GetScreenHeight()) - box_b.height;   }
        else
            if (box_b.y <= screen_upper_limit)
                box_b.y = screen_upper_limit;

        // Check boxes collision
        collision = c.CheckCollisionRecs(box_a, box_b);

        // Get collision rectangle (only on collision)
        if (collision)
            box_collision = c.GetCollisionRec(box_a, box_b);

        // Pause Box A movement
        if (c.IsKeyPressed(c.KEY_SPACE)) pause = !pause;
        //----------------------------------------------------------------------------------

        // Draw
        //---------------------------------------------------------------------------------
        c.BeginDrawing();
        defer c.EndDrawing();

        c.ClearBackground(c.RAYWHITE);
        c.DrawRectangle(0, 0, screen_width, screen_upper_limit, if (collision) c.RED else c.BLACK);

        c.DrawRectangleRec(box_a, c.GOLD);
        c.DrawRectangleRec(box_b, c.BLUE);

        if (collision)
        {
            // Draw collision area
            c.DrawRectangleRec(box_collision, c.LIME);

            // Draw collision message
            c.DrawText("COLLISION!", @divTrunc(c.GetScreenWidth(), 2) - @divTrunc(c.MeasureText("COLLISION!", 20), 2), screen_upper_limit / 2 - 10, 20, c.BLACK);

            // Draw collision area
            c.DrawText(c.TextFormat("Collision Area: %i", @intFromFloat(c_int, box_collision.width) * @intFromFloat(c_int, box_collision.height)), @divTrunc(c.GetScreenWidth(), 2) - 100, screen_upper_limit + 10, 20, c.BLACK);
        }

        c.DrawFPS(10, 10);
        //---------------------------------------------------------------------------------
    }
}
