// build with `zig build-exe main.zig -lc -lraylib`

// This is a Zig version of a raylib example from
// https://github.com/raysan5/raylib/
// It is distributed under the same license as the original - unmodified zlib/libpng license
// Header from the original source code follows below:

///*******************************************************************************************
//*
//*   raylib [core] example - Input Gestures Detection
//*
//*   Example originally created with raylib 1.4, last time updated with raylib 4.2
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
    const max_gesture_strings = 20;

    c.InitWindow(screen_width, screen_height, "raylib [core] example - input gestures");
    defer c.CloseWindow(); // Close window and OpenGL context

    var touch_pos = c.Vector2{ .x = 0.0, .y = 0.0 };
    const touch_area = c.Rectangle{ .x = 220, .y = 10, .width = screen_width - 230, .height = screen_height - 20 };

    var gestures_count: usize = 0;
    var gesture_strings: [max_gesture_strings][32]u8 = undefined;

    var current_gesture: c_int = c.GESTURE_NONE;
    var last_gesture: c_int = c.GESTURE_NONE;

    //c.SetGesturesEnabled(0b0000000000001001); // Enable only some gestures to be detected

    c.SetTargetFPS(60);

    while (!c.WindowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        last_gesture = current_gesture;
        current_gesture = c.GetGestureDetected();
        touch_pos = c.GetTouchPosition(0);

        if (c.CheckCollisionPointRec(touch_pos, touch_area) and (current_gesture != c.GESTURE_NONE))
        {
            if (current_gesture != last_gesture)
            {
                switch (current_gesture)
                {
                    c.GESTURE_TAP =>         _ = c.TextCopy(&gesture_strings[gestures_count], "GESTURE TAP"),
                    c.GESTURE_DOUBLETAP =>   _ = c.TextCopy(&gesture_strings[gestures_count], "GESTURE DOUBLETAP"),
                    c.GESTURE_HOLD =>        _ = c.TextCopy(&gesture_strings[gestures_count], "GESTURE HOLD"),
                    c.GESTURE_DRAG =>        _ = c.TextCopy(&gesture_strings[gestures_count], "GESTURE DRAG"),
                    c.GESTURE_SWIPE_RIGHT => _ = c.TextCopy(&gesture_strings[gestures_count], "GESTURE SWIPE RIGHT"),
                    c.GESTURE_SWIPE_LEFT =>  _ = c.TextCopy(&gesture_strings[gestures_count], "GESTURE SWIPE LEFT"),
                    c.GESTURE_SWIPE_UP =>    _ = c.TextCopy(&gesture_strings[gestures_count], "GESTURE SWIPE UP"),
                    c.GESTURE_SWIPE_DOWN =>  _ = c.TextCopy(&gesture_strings[gestures_count], "GESTURE SWIPE DOWN"),
                    c.GESTURE_PINCH_IN =>    _ = c.TextCopy(&gesture_strings[gestures_count], "GESTURE PINCH IN"),
                    c.GESTURE_PINCH_OUT =>   _ = c.TextCopy(&gesture_strings[gestures_count], "GESTURE PINCH OUT"),
                    else => {},
                }
                gestures_count += 1;

                // Reset gestures strings
                if (gestures_count >= max_gesture_strings)
                {
                    // --     !! captured values are immutable !!    --
                    // -- see https://ziglearn.org/chapter-1/#unions --
                    //for (gesture_strings) |gesture_string|
                    //    _ = c.TextCopy(&gesture_string, "\x00");

                    for (0..gesture_strings.len) |i|
                        _ = c.TextCopy(&gesture_strings[i], "\x00");

                    gestures_count = 0;
                }
            }
        }
        //----------------------------------------------------------------------------------

        // Draw
        //---------------------------------------------------------------------------------
        c.BeginDrawing();
        defer c.EndDrawing();

        c.ClearBackground(c.RAYWHITE);

        c.DrawRectangleRec(touch_area, c.GRAY);
        c.DrawRectangle(225, 15, screen_width - 240, screen_height - 30, c.RAYWHITE);

        c.DrawText("GESTURES TEST AREA", screen_width - 270, screen_height - 40, 20, c.Fade(c.GRAY, 0.5));

        //for (0..gestures_count) |i| // -- i is usize, must be c_int in calls to c.DrawRectangle
        var i: c_int = 0;             // -- we could use @intCast, but let's go with while loop
        while (i < gestures_count) : (i += 1)
        {
            if (i & 1 == 0)
            {   c.DrawRectangle(10, 30 + 20*i, 200, 20, c.Fade(c.LIGHTGRAY, 0.5));   }
            else
                c.DrawRectangle(10, 30 + 20*i, 200, 20, c.Fade(c.LIGHTGRAY, 0.3));

            if (i < gestures_count - 1)
            {   c.DrawText(&gesture_strings[@intCast(i)], 35, 36 + 20*i, 10, c.DARKGRAY);   }
            else
                c.DrawText(&gesture_strings[@intCast(i)], 35, 36 + 20*i, 10, c.MAROON);
        }

        c.DrawRectangleLines(10, 29, 200, screen_height - 50, c.GRAY);
        c.DrawText("DETECTED GESTURES", 50, 15, 10, c.GRAY);

        if (current_gesture != c.GESTURE_NONE)
            c.DrawCircleV(touch_pos, 30, c.MAROON);
        //---------------------------------------------------------------------------------
    }
}
