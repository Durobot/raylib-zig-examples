// build with `zig build-exe main.zig -lc -lraylib`

// This is a Zig version of a raylib example from
// https://github.com/raysan5/raylib/
// It is distributed under the same license as the original - unmodified zlib/libpng license
// Header from the original source code follows below:

///*******************************************************************************************
//*
//*   raylib [shapes] example - Colors palette
//*
//*   Example originally created with raylib 1.0, last time updated with raylib 2.5
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
    const max_colors_count = 21; // Number of colors available

    c.InitWindow(screen_width, screen_height, "raylib [shapes] example - colors palette");
    defer c.CloseWindow(); // Close window and OpenGL context

    const clrs = [max_colors_count]c.Color
    {
        c.DARKGRAY, c.MAROON, c.ORANGE, c.DARKGREEN, c.DARKBLUE, c.DARKPURPLE, c.DARKBROWN,
        c.GRAY, c.RED, c.GOLD, c.LIME, c.BLUE, c.VIOLET, c.BROWN, c.LIGHTGRAY, c.PINK, c.YELLOW,
        c.GREEN, c.SKYBLUE, c.PURPLE, c.BEIGE
    };

    const clr_names = [max_colors_count][*:0]const u8
    {
        "DARKGRAY", "MAROON", "ORANGE", "DARKGREEN", "DARKBLUE", "DARKPURPLE",
        "DARKBROWN", "GRAY", "RED", "GOLD", "LIME", "BLUE", "VIOLET", "BROWN",
        "LIGHTGRAY", "PINK", "YELLOW", "GREEN", "SKYBLUE", "PURPLE", "BEIGE"
    };

    // Fills colorsRecs data (for every rectangle)
    const clr_rects = comptime
    init_rects:
    {
        var rects: [max_colors_count]c.Rectangle = undefined;
        for (0..max_colors_count) |i|
        {
            rects[i].x = 20.0 + 100.0 * @floatFromInt(comptime_float, i % 7) + 10.0 * @floatFromInt(comptime_float, i % 7);
            rects[i].y = 80.0 + 100.0 * @floatFromInt(comptime_float, i / 7) + 10.0 * @floatFromInt(comptime_float, i / 7);
            rects[i].width = 100.0;
            rects[i].height = 100.0;
        }
        break :init_rects rects;
    };

    var clr_states = [_]c_int{ 0 } ** max_colors_count; // Color state: 0-DEFAULT, 1-MOUSE_HOVER

    c.SetTargetFPS(60); // Set our game to run at 60 frames-per-second

    while (!c.WindowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        const mouse_point = c.GetMousePosition();
        for (0..max_colors_count) |i|
        {
            if (c.CheckCollisionPointRec(mouse_point, clr_rects[i])) { clr_states[i] = 1; }
            else clr_states[i] = 0;
        }
        //----------------------------------------------------------------------------------

        // Draw
        //---------------------------------------------------------------------------------
        c.BeginDrawing();
        defer c.EndDrawing();

        c.ClearBackground(c.RAYWHITE);

        c.DrawText("raylib colors palette", 28, 42, 20, c.BLACK);
        c.DrawText("press SPACE to see all colors",
                   c.GetScreenWidth() - 180, c.GetScreenHeight() - 40, 10, c.GRAY);

        for (0..max_colors_count) |i| // Draw all rectangles
        {
            c.DrawRectangleRec(clr_rects[i], c.Fade(clrs[i], if (clr_states[i] != 0) 0.6 else 1.0));

            if (c.IsKeyDown(c.KEY_SPACE) or clr_states[i] != 0)
            {
                c.DrawRectangle(@intFromFloat(c_int, clr_rects[i].x),
                                @intFromFloat(c_int, clr_rects[i].y + clr_rects[i].height) - 26,
                                @intFromFloat(c_int, clr_rects[i].width), 20, c.BLACK);
                c.DrawRectangleLinesEx(clr_rects[i], 6, c.Fade(c.BLACK, 0.3));
                c.DrawText(clr_names[i],
                           @intFromFloat(c_int, clr_rects[i].x + clr_rects[i].width) - c.MeasureText(clr_names[i], 10) - 12,
                           @intFromFloat(c_int, clr_rects[i].y + clr_rects[i].height) - 20, 10, clrs[i]);
            }
        }
        //---------------------------------------------------------------------------------
    }
}

//inline fn initRects(comptime siz: usize) [siz]c.Rectangle
//{
//    var rects: [siz]c.Rectangle = undefined;
//    inline for (0..siz) |i|
//    {
//        rects[i].x = 20.0 + 100.0 * @floatFromInt(comptime_float, i % 7) + 10.0 * @floatFromInt(comptime_float, i % 7);
//        rects[i].y = 80.0 + 100.0 * (@floatFromInt(comptime_float, i) / 7.0) + 10.0 * (@floatFromInt(comptime_float, i) / 7.0);
//        rects[i].width = 100.0;
//        rects[i].height = 100.0;
//    }
//    return rects;
//}
