// build with `zig build-exe main.zig -lc -lraylib`

// This is a Zig version of a raylib example from
// https://github.com/raysan5/raylib/
// It is distributed under the same license as the original - unmodified zlib/libpng license
// Header from the original source code follows below:

///*******************************************************************************************
//*
//*   raylib [shapes] example - raylib logo animation
//*
//*   Example originally created with raylib 2.5, last time updated with raylib 4.0
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

    c.InitWindow(screen_width, screen_height, "raylib [shapes] example - raylib logo animation");
    defer c.CloseWindow(); // Close window and OpenGL context

    const logo_pos_x = screen_width / 2 - 128;
    const logo_pos_y = screen_height / 2 - 128;

    var frames_counter: u32 = 0;
    var letters_count: u32 = 0;

    var top_side_rec_width: c_int = 16; // Easier to go with c_int than coerce other type to it many
    var left_side_rec_height: c_int = 16; // times.

    var bottom_side_rec_width: c_int = 16;
    var right_side_rec_height: c_int = 16;

    var state: u32 = 0; // Tracking animation states (State Machine)
    var alpha: f32 = 1.0; // Useful for fading

    c.SetTargetFPS(60); // Set our game to run at 60 frames-per-second

    while (!c.WindowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        if (state == 0) // State 0: Small box blinking
        {
            frames_counter += 1;

            if (frames_counter == 120)
            {
                state = 1;
                frames_counter = 0; // Reset counter... will be used later...
            }
        }
        else if (state == 1) // State 1: Top and left bars growing
        {
            top_side_rec_width += 4;
            left_side_rec_height += 4;

            if (top_side_rec_width == 256) state = 2;
        }
        else if (state == 2) // State 2: Bottom and right bars growing
        {
            bottom_side_rec_width += 4;
            right_side_rec_height += 4;

            if (bottom_side_rec_width == 256) state = 3;
        }
        else if (state == 3) // State 3: Letters appearing (one by one)
        {
            frames_counter += 1;

            //if (frames_counter/12 != 0)       // Every 12 frames, one more letter!
            if (frames_counter >= 12) // Dividing frames_counter by 12 to check if it is >= 12 is kinda weird
            {
                letters_count += 1;
                frames_counter = 0;
            }

            if (letters_count >= 10) // When all letters have appeared, just fade out everything
            {
                alpha -= 0.02;

                if (alpha <= 0.0)
                {
                    alpha = 0.0;
                    state = 4;
                }
            }
        }
        else if (state == 4) // State 4: Reset and Replay
        {
            if (c.IsKeyPressed(c.KEY_R))
            {
                frames_counter = 0;
                letters_count = 0;

                top_side_rec_width = 16;
                left_side_rec_height = 16;

                bottom_side_rec_width = 16;
                right_side_rec_height = 16;

                alpha = 1.0;
                state = 0; // Return to State 0
            }
        }
        //----------------------------------------------------------------------------------

        // Draw
        //---------------------------------------------------------------------------------
        c.BeginDrawing();
        defer c.EndDrawing();

        c.ClearBackground(c.RAYWHITE);

        // I have switched from ifs to switch here.
        // Pun intented.
        switch (state)
        {
            0 =>
            {
                if ((frames_counter / 15) % 2 != 0)
                    c.DrawRectangle(logo_pos_x, logo_pos_y, 16, 16, c.BLACK);
            },
            1 =>
            {
                c.DrawRectangle(logo_pos_x, logo_pos_y, top_side_rec_width, 16, c.BLACK);
                c.DrawRectangle(logo_pos_x, logo_pos_y, 16, left_side_rec_height, c.BLACK);
            },
            2 =>
            {
                c.DrawRectangle(logo_pos_x, logo_pos_y, top_side_rec_width, 16, c.BLACK);
                c.DrawRectangle(logo_pos_x, logo_pos_y, 16, left_side_rec_height, c.BLACK);

                c.DrawRectangle(logo_pos_x + 240, logo_pos_y, 16, right_side_rec_height, c.BLACK);
                c.DrawRectangle(logo_pos_x, logo_pos_y + 240, bottom_side_rec_width, 16, c.BLACK);
            },
            3 =>
            {
                c.DrawRectangle(logo_pos_x, logo_pos_y, top_side_rec_width, 16, c.Fade(c.BLACK, alpha));
                c.DrawRectangle(logo_pos_x, logo_pos_y + 16, 16, left_side_rec_height - 32, c.Fade(c.BLACK, alpha));

                c.DrawRectangle(logo_pos_x + 240, logo_pos_y + 16, 16, right_side_rec_height - 32, c.Fade(c.BLACK, alpha));
                c.DrawRectangle(logo_pos_x, logo_pos_y + 240, bottom_side_rec_width, 16, c.Fade(c.BLACK, alpha));

                c.DrawRectangle(@divTrunc(c.GetScreenWidth(), 2) - 112,
                                @divTrunc(c.GetScreenHeight(), 2) - 112, 224, 224,
                                c.Fade(c.RAYWHITE, alpha));

                c.DrawText(c.TextSubtext("raylib", 0, @intCast(letters_count)), // c_int
                           @divTrunc(c.GetScreenWidth(), 2) - 44,
                           @divTrunc(c.GetScreenHeight(), 2) + 48, 50, c.Fade(c.BLACK, alpha));
            },
            4 => c.DrawText("[R] REPLAY", 340, 200, 20, c.GRAY),
            else => {} // switches in Zig must be exhaustive
        }
        //---------------------------------------------------------------------------------
    }
}
