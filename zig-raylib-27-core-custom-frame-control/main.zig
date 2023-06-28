// build with `zig build-exe main.zig -lc -lraylib`

// This is a Zig version of a raylib example from
// https://github.com/raysan5/raylib/
// It is distributed under the same license as the original - unmodified zlib/libpng license
// Header from the original source code follows below:

//*******************************************************************************************
//
//   raylib [core] example - custom frame control
//
//   NOTE: WARNING: This is an example for advance users willing to have full control over
//   the frame processes. By default, EndDrawing() calls the following processes:
//       1. Draw remaining batch data: rlDrawRenderBatchActive()
//       2. SwapScreenBuffer()
//       3. Frame time control: WaitTime()
//       4. PollInputEvents()
//
//   To avoid steps 2, 3 and 4, flag SUPPORT_CUSTOM_FRAME_CONTROL can be enabled in
//   config.h (it requires recompiling raylib). This way those steps are up to the user.
//
//   Note that enabling this flag invalidates some functions:
//       - GetFrameTime()
//       - SetTargetFPS()
//       - GetFPS()
//
//   Example originally created with raylib 4.0, last time updated with raylib 4.0
//
//   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//   BSD-like license that allows static linking with closed source software
//
//   Copyright (c) 2021-2023 Ramon Santamaria (@raysan5)
//
//********************************************************************************************

const c = @cImport(
{
    @cInclude("raylib.h");
});

pub fn main() void
{
    const screenWidth = 800;
    const screenHeight = 450;

    c.InitWindow(screenWidth, screenHeight, "raylib [core] example - custom frame control");
    defer c.CloseWindow(); // Close window and OpenGL context

    // Custom timming variables
    var prev_time: f64 = c.GetTime();   // Previous time measure
    var cur_time: f64 = 0.0;            // Current time measure
    var update_draw_time: f64 = 0.0;    // Update + Draw time
    var wait_time: f64 = 0.0;           // Wait time (if target fps required)
    var delta_time: f32 = 0.0;          // Frame time (Update + Draw + Wait time)

    var time_counter: f32 = 0.0;        // Accumulative time counter (seconds)
    var position: f32 = 0.0;            // Circle position
    var pause = false;                  // Pause control flag

    var target_fps: i32 = 60;                 // Our initial target fps
    //--------------------------------------------------------------------------------------

    while (!c.WindowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        c.PollInputEvents(); // Poll input events (SUPPORT_CUSTOM_FRAME_CONTROL)

        if (c.IsKeyPressed(c.KEY_SPACE)) pause = !pause;

        if (c.IsKeyPressed(c.KEY_UP)) { target_fps += 20; }
        else if (c.IsKeyPressed(c.KEY_DOWN)) target_fps -= 20;

        if (target_fps < 0) target_fps = 0;

        if (!pause)
        {
            position += 200 * delta_time;  // We move at 200 pixels per second
            if (@as(c_int, @intFromFloat(position)) >= c.GetScreenWidth()) position = 0.0;
            time_counter += delta_time;   // We count time (seconds)
        }
        //----------------------------------------------------------------------------------

        // Draw
        //---------------------------------------------------------------------------------
        {
            c.BeginDrawing();
            defer c.EndDrawing();

            c.ClearBackground(c.RAYWHITE);

            // @intCast -> usize
            for (0..@intCast(@divTrunc(c.GetScreenWidth(), 200))) |i|
                c.DrawRectangle(200 * @as(c_int, @intCast(i)), 0, 1, c.GetScreenHeight(), c.SKYBLUE);

            c.DrawCircle(@intFromFloat(position), @divTrunc(c.GetScreenHeight(), 2) - 25, 50, c.RED);

            c.DrawText(c.TextFormat("%03.0f ms", time_counter * 1000.0),
                       @as(c_int, @intFromFloat(position)) - 40,
                       @divTrunc(c.GetScreenHeight(), 2) - 100, 20, c.MAROON);
            c.DrawText(c.TextFormat("PosX: %03.0f", position),
                       @as(c_int, @intFromFloat(position)) - 50,
                       @divTrunc(c.GetScreenHeight(), 2) + 40, 20, c.BLACK);

            c.DrawText("Circle is moving at a constant 200 pixels/sec,\nindependently of the frame rate.", 10, 10, 20, c.DARKGRAY);
            c.DrawText("PRESS SPACE to PAUSE MOVEMENT", 10, c.GetScreenHeight() - 60, 20, c.GRAY);
            c.DrawText("PRESS UP | DOWN to CHANGE TARGET FPS", 10, c.GetScreenHeight() - 30, 20, c.GRAY);
            c.DrawText(c.TextFormat("TARGET FPS: %i", target_fps), c.GetScreenWidth() - 220, 10, 20, c.LIME);
            // -- This code causes Zig compiler (0.11.0-dev.3859+88284c124) to segfault, see
            // -- https://github.com/ziglang/zig/issues/16197
            //c.DrawText(c.TextFormat("CURRENT FPS: %i",
            //                        if (delta_time == 0.0) 0 else @intFromFloat(1.0 / delta_time)),
            //           c.GetScreenWidth() - 220, 40, 20, c.GREEN);
            const fps: c_int = if (delta_time == 0.0) 0 else @intFromFloat(1.0 / delta_time);
            c.DrawText(c.TextFormat("CURRENT FPS: %i", fps), c.GetScreenWidth() - 220, 40, 20, c.GREEN);
        }


        // NOTE: In case raylib is configured to SUPPORT_CUSTOM_FRAME_CONTROL,
        // Events polling, screen buffer swap and frame time control must be managed by the user
        c.SwapScreenBuffer();         // Flip the back buffer to screen (front buffer)

        cur_time = c.GetTime();
        update_draw_time = cur_time - prev_time;

        if (target_fps > 0)          // We want a fixed frame rate
        {
            wait_time = (1.0 / @as(f64, @floatFromInt(target_fps))) - update_draw_time;
            if (wait_time > 0.0)
            {
                c.WaitTime(wait_time);
                cur_time = c.GetTime();
                delta_time = @floatCast(cur_time - prev_time); // @floatCast -> f32
            }
        }
        else // @floatCast -> f32
            delta_time = @floatCast(update_draw_time); // Framerate could be variable

        prev_time = cur_time;
        //---------------------------------------------------------------------------------
    }
}
