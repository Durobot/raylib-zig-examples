// This is a Zig version of a raylib example from
// https://github.com/raysan5/raylib/
// It is distributed under the same license as the original - unmodified zlib/libpng license
// Header from the original source code follows below:

///*******************************************************************************************
//*
//*   raylib [shapes] example - easings ball anim
//*
//*   Example originally created with raylib 2.5, last time updated with raylib 2.5
//*
//*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//*   BSD-like license that allows static linking with closed source software
//*
//*   Copyright (c) 2014-2023 Ramon Santamaria (@raysan5)
//*
//********************************************************************************************/


// Download reasings.h from
// https://github.com/raysan5/raylib/blob/master/examples/others/reasings.h
// and copy it to this project's folder.
// Build with `zig build-exe main.zig -idirafter ./ -lc -lraylib`

const c = @cImport(
{
    @cInclude("raylib.h");
    @cInclude("reasings.h");
});

pub fn main() void
{
    const screen_width = 800;
    const screen_height = 450;

    c.InitWindow(screen_width, screen_height, "raylib [shapes] example - easings ball anim");
    defer c.CloseWindow(); // Close window and OpenGL context

    // Ball variable value to be animated with easings
    var ball_pos_x: i32 = -100;
    var ball_radius: i32 = 20;
    var ball_alpha: f32 = 0.0;

    var state: u32 = 0;
    var frames_counter: u32 = 0;

    c.SetTargetFPS(60);

    while (!c.WindowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        if (state == 0)             // Move ball position X with easing
        {
            frames_counter += 1;
            ball_pos_x = @floatToInt(i32, c.EaseElasticOut(@intToFloat(f32, frames_counter), -100, screen_width/2.0 + 100, 120));

            if (frames_counter >= 120)
            {
                frames_counter = 0;
                state = 1;
            }
        }
        else if (state == 1)        // Increase ball radius with easing
        {
            frames_counter += 1;
            ball_radius = @floatToInt(i32, c.EaseElasticIn(@intToFloat(f32, frames_counter), 20, 500, 200));

            if (frames_counter >= 200)
            {
                frames_counter = 0;
                state = 2;
            }
        }
        else if (state == 2)        // Change ball alpha with easing (background color blending)
        {
            frames_counter += 1;
            ball_alpha = c.EaseCubicOut(@intToFloat(f32, frames_counter), 0.0, 1.0, 200);

            if (frames_counter >= 200)
            {
                frames_counter = 0;
                state = 3;
            }
        }
        else if (state == 3)        // Reset state to play again
        {
            if (c.IsKeyPressed(c.KEY_ENTER))
            {
                // Reset required variables to play again
                ball_pos_x = -100;
                ball_radius = 20;
                ball_alpha = 0.0;
                state = 0;
            }
        }

        if (c.IsKeyPressed(c.KEY_R)) frames_counter = 0;
        //----------------------------------------------------------------------------------

        // Draw
        //---------------------------------------------------------------------------------
        c.BeginDrawing();
        defer c.EndDrawing();

        c.ClearBackground(c.RAYWHITE);

        if (state >= 2)
            c.DrawRectangle(0, 0, screen_width, screen_height, c.GREEN);
        c.DrawCircle(ball_pos_x, 200, @intToFloat(f32, ball_radius), c.Fade(c.RED, 1.0 - ball_alpha));

        if (state == 3)
            c.DrawText("PRESS [ENTER] TO PLAY AGAIN!", 240, 200, 20, c.BLACK);
        //---------------------------------------------------------------------------------
    }
}
