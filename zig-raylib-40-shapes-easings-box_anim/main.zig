// This is a Zig version of a raylib example from
// https://github.com/raysan5/raylib/
// It is distributed under the same license as the original - unmodified zlib/libpng license
// Header from the original source code follows below:

///*******************************************************************************************
//*
//*   raylib [shapes] example - easings box anim
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

    c.InitWindow(screen_width, screen_height, "raylib [shapes] example - easings box anim");
    defer c.CloseWindow(); // Close window and OpenGL context

    // Box variables to be animated with easings
    var rec = c.Rectangle{ .x = @floatFromInt(f32, c.GetScreenWidth()) / 2.0, .y = -100, .width = 100, .height = 100 };
    var rotation: f32 = 0.0;
    var alpha: f32 = 1.0;

    var state: u32 = 0;
    var frames_counter: u32 = 0;

    c.SetTargetFPS(60);

    while (!c.WindowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        switch (state)
        {
            0 =>      // Move box down to center of screen
            {
                frames_counter += 1;

                // NOTE: Remember that 3rd parameter of easing function refers to
                // desired value variation, do not confuse it with expected final value!
                rec.y = c.EaseElasticOut(@floatFromInt(f32, frames_counter), -100, @floatFromInt(f32, c.GetScreenHeight()) / 2.0 + 100, 120);

                if (frames_counter >= 120)
                {
                    frames_counter = 0;
                    state = 1;
                }
            },
            1 =>      // Scale box to an horizontal bar
            {
                frames_counter += 1;
                rec.height = c.EaseBounceOut(@floatFromInt(f32, frames_counter), 100, -90, 120);
                rec.width = c.EaseBounceOut(@floatFromInt(f32, frames_counter), 100, @floatFromInt(f32, c.GetScreenWidth()), 120);

                if (frames_counter >= 120)
                {
                    frames_counter = 0;
                    state = 2;
                }
            },
            2 =>      // Rotate horizontal bar rectangle
            {
                frames_counter += 1;
                rotation = c.EaseQuadOut(@floatFromInt(f32, frames_counter), 0.0, 270.0, 240);

                if (frames_counter >= 240)
                {
                    frames_counter = 0;
                    state = 3;
                }
            },
            3 =>      // Increase bar size to fill all screen
            {
                frames_counter += 1;
                rec.height = c.EaseCircOut(@floatFromInt(f32, frames_counter), 10, @floatFromInt(f32, c.GetScreenWidth()), 120);

                if (frames_counter >= 120)
                {
                    frames_counter = 0;
                    state = 4;
                }
            },
            4 =>      // Fade out animation
            {
                frames_counter += 1;
                alpha = c.EaseSineOut(@floatFromInt(f32, frames_counter), 1.0, -1.0, 160);

                if (frames_counter >= 160)
                {
                    frames_counter = 0;
                    state = 5;
                }
            },
            else => {}
        }

        // Reset animation at any moment
        if (c.IsKeyPressed(c.KEY_SPACE))
        {
            rec = .{ .x = @floatFromInt(f32, c.GetScreenWidth()) / 2.0, .y = -100.0, .width = 100.0, .height = 100.0 };
            rotation = 0.0;
            alpha = 1.0;
            state = 0;
            frames_counter = 0;
        }
        //----------------------------------------------------------------------------------

        // Draw
        //---------------------------------------------------------------------------------
        c.BeginDrawing();
        defer c.EndDrawing();

        c.ClearBackground(c.RAYWHITE);

        c.DrawRectanglePro(rec, .{ .x = rec.width / 2.0, .y = rec.height / 2.0 }, rotation, c.Fade(c.BLACK, alpha));

        c.DrawText("PRESS [SPACE] TO RESET BOX ANIMATION!", 10, c.GetScreenHeight() - 25, 20, c.LIGHTGRAY);
        //---------------------------------------------------------------------------------
    }
}
