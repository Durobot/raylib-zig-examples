// build with `zig build-exe main.zig -lc -lraylib`

// This is a Zig version of a raylib example from
// https://github.com/raysan5/raylib/
// It is distributed under the same license as the original - unmodified zlib/libpng license
// Header from the original source code follows below:

///*******************************************************************************************
//*
//*   raylib [core] example - window flags
//*
//*   Example originally created with raylib 3.5, last time updated with raylib 3.5
//*
//*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//*   BSD-like license that allows static linking with closed source software
//*
//*   Copyright (c) 2020-2023 Ramon Santamaria (@raysan5)
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

    // Possible window flags
    //
    // FLAG_VSYNC_HINT
    // FLAG_FULLSCREEN_MODE    -> not working properly -> wrong scaling!
    // FLAG_WINDOW_RESIZABLE
    // FLAG_WINDOW_UNDECORATED
    // FLAG_WINDOW_TRANSPARENT
    // FLAG_WINDOW_HIDDEN
    // FLAG_WINDOW_MINIMIZED   -> Not supported on window creation
    // FLAG_WINDOW_MAXIMIZED   -> Not supported on window creation
    // FLAG_WINDOW_UNFOCUSED
    // FLAG_WINDOW_TOPMOST
    // FLAG_WINDOW_HIGHDPI     -> errors after minimize-resize, fb size is recalculated
    // FLAG_WINDOW_ALWAYS_RUN
    // FLAG_MSAA_4X_HINT

    // Set configuration flags for window creation
    //SetConfigFlags(FLAG_VSYNC_HINT | FLAG_MSAA_4X_HINT | FLAG_WINDOW_HIGHDPI);
    c.InitWindow(screen_width, screen_height, "raylib [core] example - window flags");
    defer c.CloseWindow(); // Close window and OpenGL context

    var ball_pos = c.Vector2{ .x = @as(f32, @floatFromInt(c.GetScreenWidth())) / 2.0, // f32
                              .y = @as(f32, @floatFromInt(c.GetScreenHeight())) / 2.0 }; // f32
    var ball_speed = c.Vector2{ .x = 5.0, .y = 4.0 };
    const ball_radius = 20.0;

    var frames_counter: c_int = 0;

    //c.SetTargetFPS(60); // Set our game to run at 60 frames-per-second

    while (!c.WindowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        if (c.IsKeyPressed(c.KEY_F)) c.ToggleFullscreen();  // modifies window size when scaling!

        if (c.IsKeyPressed(c.KEY_R))
        {
            if (c.IsWindowState(c.FLAG_WINDOW_RESIZABLE))
            {   c.ClearWindowState(c.FLAG_WINDOW_RESIZABLE);   }
            else
                c.SetWindowState(c.FLAG_WINDOW_RESIZABLE);
        }

        if (c.IsKeyPressed(c.KEY_D))
        {
            if (c.IsWindowState(c.FLAG_WINDOW_UNDECORATED))
            {   c.ClearWindowState(c.FLAG_WINDOW_UNDECORATED);   }
            else
                c.SetWindowState(c.FLAG_WINDOW_UNDECORATED);
        }

        if (c.IsKeyPressed(c.KEY_H))
        {
            if (!c.IsWindowState(c.FLAG_WINDOW_HIDDEN))
                c.SetWindowState(c.FLAG_WINDOW_HIDDEN);

            frames_counter = 0;
        }

        if (c.IsWindowState(c.FLAG_WINDOW_HIDDEN))
        {
            frames_counter += 1;
            if (frames_counter >= 240)
                c.ClearWindowState(c.FLAG_WINDOW_HIDDEN); // Show window after 3 seconds
        }

        if (c.IsKeyPressed(c.KEY_N))
        {
            if (!c.IsWindowState(c.FLAG_WINDOW_MINIMIZED))
                c.MinimizeWindow();

            frames_counter = 0;
        }

        if (c.IsWindowState(c.FLAG_WINDOW_MINIMIZED))
        {
            frames_counter += 1;
            if (frames_counter >= 240)
                c.RestoreWindow(); // Restore window after 3 seconds
        }

        if (c.IsKeyPressed(c.KEY_M))
        {
            // NOTE: Requires FLAG_WINDOW_RESIZABLE enabled!
            if (c.IsWindowState(c.FLAG_WINDOW_MAXIMIZED))
            {   c.RestoreWindow();   }
            else
                c.MaximizeWindow();
        }

        if (c.IsKeyPressed(c.KEY_U))
        {
            if (c.IsWindowState(c.FLAG_WINDOW_UNFOCUSED))
            {   c.ClearWindowState(c.FLAG_WINDOW_UNFOCUSED);   }
            else
                c.SetWindowState(c.FLAG_WINDOW_UNFOCUSED);
        }

        if (c.IsKeyPressed(c.KEY_T))
        {
            if (c.IsWindowState(c.FLAG_WINDOW_TOPMOST))
            {   c.ClearWindowState(c.FLAG_WINDOW_TOPMOST);   }
            else
                c.SetWindowState(c.FLAG_WINDOW_TOPMOST);
        }

        if (c.IsKeyPressed(c.KEY_A))
        {
            if (c.IsWindowState(c.FLAG_WINDOW_ALWAYS_RUN))
            {   c.ClearWindowState(c.FLAG_WINDOW_ALWAYS_RUN);   }
            else
                c.SetWindowState(c.FLAG_WINDOW_ALWAYS_RUN);
        }

        if (c.IsKeyPressed(c.KEY_V))
        {
            if (c.IsWindowState(c.FLAG_VSYNC_HINT))
            {   c.ClearWindowState(c.FLAG_VSYNC_HINT);   }
            else
                c.SetWindowState(c.FLAG_VSYNC_HINT);
        }

        // Bouncing ball logic
        ball_pos.x += ball_speed.x;
        ball_pos.y += ball_speed.y;
        if ((ball_pos.x >= (@as(f32, @floatFromInt(c.GetScreenWidth())) - ball_radius)) or (ball_pos.x <= ball_radius))
            ball_speed.x = -ball_speed.x;
        if ((ball_pos.y >= (@as(f32, @floatFromInt(c.GetScreenHeight())) - ball_radius)) or (ball_pos.y <= ball_radius))
            ball_speed.y = -ball_speed.y;
        //----------------------------------------------------------------------------------

        // Draw
        //---------------------------------------------------------------------------------
        c.BeginDrawing();
        defer c.EndDrawing();

        if (c.IsWindowState(c.FLAG_WINDOW_TRANSPARENT))
        {   c.ClearBackground(c.BLANK);   }
        else
            c.ClearBackground(c.RAYWHITE);

        c.DrawCircleV(ball_pos, ball_radius, c.MAROON);
        c.DrawRectangleLinesEx(.{ .x = 0.0, .y = 0,
                                  .width = @floatFromInt(c.GetScreenWidth()),
                                  .height = @floatFromInt(c.GetScreenHeight()) }, 4, c.RAYWHITE);

        c.DrawCircleV(c.GetMousePosition(), 10, c.DARKBLUE);

        c.DrawFPS(10, 10);

        c.DrawText(c.TextFormat("Screen Size: [%i, %i]", c.GetScreenWidth(), c.GetScreenHeight()), 10, 40, 10, c.GREEN);

        // Draw window state info
        c.DrawText("Following flags can be set after window creation:", 10, 60, 10, c.GRAY);
        if (c.IsWindowState(c.FLAG_FULLSCREEN_MODE)) { c.DrawText("[F] FLAG_FULLSCREEN_MODE: on", 10, 80, 10, c.LIME); }
        else c.DrawText("[F] FLAG_FULLSCREEN_MODE: off", 10, 80, 10, c.MAROON);
        if (c.IsWindowState(c.FLAG_WINDOW_RESIZABLE)) { c.DrawText("[R] FLAG_WINDOW_RESIZABLE: on", 10, 100, 10, c.LIME); }
        else c.DrawText("[R] FLAG_WINDOW_RESIZABLE: off", 10, 100, 10, c.MAROON);
        if (c.IsWindowState(c.FLAG_WINDOW_UNDECORATED)) { c.DrawText("[D] FLAG_WINDOW_UNDECORATED: on", 10, 120, 10, c.LIME); }
        else c.DrawText("[D] FLAG_WINDOW_UNDECORATED: off", 10, 120, 10, c.MAROON);
        if (c.IsWindowState(c.FLAG_WINDOW_HIDDEN)) { c.DrawText("[H] FLAG_WINDOW_HIDDEN: on", 10, 140, 10, c.LIME); }
        else c.DrawText("[H] FLAG_WINDOW_HIDDEN: off", 10, 140, 10, c.MAROON);
        if (c.IsWindowState(c.FLAG_WINDOW_MINIMIZED)) { c.DrawText("[N] FLAG_WINDOW_MINIMIZED: on", 10, 160, 10, c.LIME); }
        else c.DrawText("[N] FLAG_WINDOW_MINIMIZED: off", 10, 160, 10, c.MAROON);
        if (c.IsWindowState(c.FLAG_WINDOW_MAXIMIZED)) { c.DrawText("[M] FLAG_WINDOW_MAXIMIZED: on", 10, 180, 10, c.LIME); }
        else c.DrawText("[M] FLAG_WINDOW_MAXIMIZED: off", 10, 180, 10, c.MAROON);
        if (c.IsWindowState(c.FLAG_WINDOW_UNFOCUSED)) { c.DrawText("[G] FLAG_WINDOW_UNFOCUSED: on", 10, 200, 10, c.LIME); }
        else c.DrawText("[U] FLAG_WINDOW_UNFOCUSED: off", 10, 200, 10, c.MAROON);
        if (c.IsWindowState(c.FLAG_WINDOW_TOPMOST)) { c.DrawText("[T] FLAG_WINDOW_TOPMOST: on", 10, 220, 10, c.LIME); }
        else c.DrawText("[T] FLAG_WINDOW_TOPMOST: off", 10, 220, 10, c.MAROON);
        if (c.IsWindowState(c.FLAG_WINDOW_ALWAYS_RUN)) { c.DrawText("[A] FLAG_WINDOW_ALWAYS_RUN: on", 10, 240, 10, c.LIME); }
        else c.DrawText("[A] FLAG_WINDOW_ALWAYS_RUN: off", 10, 240, 10, c.MAROON);
        if (c.IsWindowState(c.FLAG_VSYNC_HINT)) { c.DrawText("[V] FLAG_VSYNC_HINT: on", 10, 260, 10, c.LIME); }
        else c.DrawText("[V] FLAG_VSYNC_HINT: off", 10, 260, 10, c.MAROON);

        c.DrawText("Following flags can only be set before window creation:", 10, 300, 10, c.GRAY);
        if (c.IsWindowState(c.FLAG_WINDOW_HIGHDPI)) { c.DrawText("FLAG_WINDOW_HIGHDPI: on", 10, 320, 10, c.LIME); }
        else c.DrawText("FLAG_WINDOW_HIGHDPI: off", 10, 320, 10, c.MAROON);
        if (c.IsWindowState(c.FLAG_WINDOW_TRANSPARENT)) { c.DrawText("FLAG_WINDOW_TRANSPARENT: on", 10, 340, 10, c.LIME); }
        else c.DrawText("FLAG_WINDOW_TRANSPARENT: off", 10, 340, 10, c.MAROON);
        if (c.IsWindowState(c.FLAG_MSAA_4X_HINT)) { c.DrawText("FLAG_MSAA_4X_HINT: on", 10, 360, 10, c.LIME); }
        else c.DrawText("FLAG_MSAA_4X_HINT: off", 10, 360, 10, c.MAROON);
        //---------------------------------------------------------------------------------
    }
}
