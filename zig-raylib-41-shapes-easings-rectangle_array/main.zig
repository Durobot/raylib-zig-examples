// This is a Zig version of a raylib example from
// https://github.com/raysan5/raylib/
// It is distributed under the same license as the original - unmodified zlib/libpng license
// Header from the original source code follows below:

///*******************************************************************************************
//*
//*   raylib [shapes] example - easings rectangle array
//*
//*   NOTE: This example requires 'easings.h' library, provided on raylib/src. Just copy
//*   the library to same directory as example or make sure it's available on include path.
//*
//*   Example originally created with raylib 2.0, last time updated with raylib 2.5
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

    const recs_width = 50;
    const recs_height = 50;

    const max_recs_x = screen_width / recs_width;
    const max_recs_y = screen_height / recs_height;

    const play_time_in_frames = 240; // At 60 fps = 4 seconds

    c.InitWindow(screen_width, screen_height, "raylib [shapes] example - easings rectangle array");
    defer c.CloseWindow(); // Close window and OpenGL context

    // Box variables to be animated with easings
    var recs: [max_recs_x * max_recs_y]c.Rectangle = comptime
    init_rectangles:
    {
        var init_rec: [max_recs_x * max_recs_y]c.Rectangle = undefined;
        for (0..max_recs_y) |y|
        {
            for (0..max_recs_x) |x|
            {
                init_rec[y * max_recs_x + x].x = recs_width / 2.0 + @floatFromInt(comptime_float, recs_width * x);
                init_rec[y * max_recs_x + x].y = recs_height / 2.0 + @floatFromInt(comptime_float, recs_height * y);
                init_rec[y * max_recs_x + x].width = recs_width;
                init_rec[y * max_recs_x + x].height = recs_height;
            }
        }
        break :init_rectangles init_rec;
    };

    var rotation: f32 = 0.0;
    var frames_counter: u32 = 0;
    var state: u32 = 0; // Rectangles animation state: 0-Playing, 1-Finished

    c.SetTargetFPS(60);

    while (!c.WindowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        if (state == 0)
        {
            frames_counter += 1;

            for (0..max_recs_x * max_recs_y) |i|
            {
                recs[i].height = c.EaseCircOut(@floatFromInt(f32, frames_counter), recs_height, -recs_height, play_time_in_frames);
                recs[i].width = c.EaseCircOut(@floatFromInt(f32, frames_counter), recs_width, -recs_width, play_time_in_frames);

                if (recs[i].height < 0) recs[i].height = 0.0;
                if (recs[i].width < 0) recs[i].width = 0.0;

                if ((recs[i].height == 0) and (recs[i].width == 0)) state = 1; // Finish playing

                rotation = c.EaseLinearIn(@floatFromInt(f32, frames_counter), 0.0, 360.0, play_time_in_frames);
            }
        }
        else if ((state == 1) and c.IsKeyPressed(c.KEY_SPACE))
        {
            // When animation has finished, press space to restart
            frames_counter = 0;

            for (0..max_recs_x * max_recs_y) |i|
            {
                recs[i].height = recs_height;
                recs[i].width = recs_width;
            }

            state = 0;
        }
        //----------------------------------------------------------------------------------

        // Draw
        //---------------------------------------------------------------------------------
        c.BeginDrawing();
        defer c.EndDrawing();

        c.ClearBackground(c.RAYWHITE);

        if (state == 0)
        {
            for (0..max_recs_x * max_recs_y) |i|
                c.DrawRectanglePro(recs[i], .{ .x = recs[i].width / 2.0, .y = recs[i].height / 2.0 }, rotation, c.RED);
        }
        else if (state == 1) c.DrawText("PRESS [SPACE] TO PLAY AGAIN!", 240, 200, 20, c.GRAY);
        //---------------------------------------------------------------------------------
    }
}
