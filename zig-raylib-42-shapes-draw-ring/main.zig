// This is a Zig version of a raylib example from
// https://github.com/raysan5/raylib/
// It is distributed under the same license as the original - unmodified zlib/libpng license
// Header from the original source code follows below:

///*******************************************************************************************
//*
//*   raylib [shapes] example - draw ring (with gui options)
//*
//*   Example originally created with raylib 2.5, last time updated with raylib 2.5
//*
//*   Example contributed by Vlad Adrian (@demizdor) and reviewed by Ramon Santamaria (@raysan5)
//*
//*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//*   BSD-like license that allows static linking with closed source software
//*
//*   Copyright (c) 2018-2023 Vlad Adrian (@demizdor) and Ramon Santamaria (@raysan5)
//*
//********************************************************************************************/

// Download raygui.h from https://github.com/raysan5/raygui/tree/master/src and copy it to this project's folder.
// Build with `zig build-exe main.zig -idirafter ./ -lc -lraylib`

// WARNING: if you're using old (pre- https://github.com/raysan5/raygui/commit/78ad65365ebae6433f60cf03a09e76b43c46cfa2)
// version of raygui.h AND unless this bug in Zig transtale - https://github.com/ziglang/zig/issues/15408 - has been fixed,
// you're going to see errors similar to this:

// /home/archie/.cache/zig/o/c95bc39f271b884ec25d6b2251a68075/cimport.zig:7631:27: error: incompatible types: 'c_int' and 'f32'
//                     value += (GetMouseDelta().y / (scrollbar.height - slider.height)) * @floatFromInt(f32, valueRange);
//                     ~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// /home/archie/.cache/zig/o/c95bc39f271b884ec25d6b2251a68075/cimport.zig:7631:21: note: type 'c_int' here
//                     value += (GetMouseDelta().y / (scrollbar.height - slider.height)) * @floatFromInt(f32, valueRange);
//                     ^~~~~
// /home/archie/.cache/zig/o/c95bc39f271b884ec25d6b2251a68075/cimport.zig:7631:87: note: type 'f32' here
//                     value += (GetMouseDelta().y / (scrollbar.height - slider.height)) * @floatFromInt(f32, valueRange);
//                              ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// Zig incorrectly skips type coercion when translating certain C code in raygui.h.
// As a workaround, edit raygui.h you have downloaded to this example's folder:
// Find the body of the function that causes Zig translate-c to stumble (currently it's `static int GuiScrollBar`, on line 4442),
// then within it, find the lines that are causing the issue (currently lines 4516, 4517):
//
// if (isVertical) value += (GetMouseDelta().y/(scrollbar.height - slider.height)*valueRange);
// else value += (GetMouseDelta().x/(scrollbar.width - slider.width)*valueRange);

// below them, two more lines (currently lines 4553, 4554):
//
// if (isVertical) value += (GetMouseDelta().y/(scrollbar.height - slider.height)*valueRange);
// else value += (GetMouseDelta().x/(scrollbar.width - slider.width)*valueRange);

// Add explicit type cast `(int)` to the value added to `value` variable in each of the 4 lines like this:
//
// if (isVertical) value += (int)(GetMouseDelta().y/(scrollbar.height - slider.height)*valueRange);
// else value += (int)(GetMouseDelta().x/(scrollbar.width - slider.width)*valueRange);

// This should fix the issue.

// Alternatively, edit the lines in cimport.zig mentioned in the error message, manually adding necessary type coercion:
// value += @intFromFloat(c_int, (GetMouseDelta().y / (scrollbar.height - slider.height)) * @floatFromInt(f32, valueRange));
//
// Also correct the lines below it:
// value += (GetMouseDelta().x / (scrollbar.width - slider.width)) * @floatFromInt(f32, valueRange);
// Add similar type coercion:
// value += @intFromFloat(c_int, (GetMouseDelta().x / (scrollbar.width - slider.width)) * @floatFromInt(f32, valueRange));
//
// Apply the same modification to each line where it is needed.
//
// Save cimport.zig and build the project again, it should compile without errors.

// You may need to do this again, if cimport.zig is regenerated by Zig :(

const c = @cImport(
{
    @cInclude("stddef.h"); // NULL
    @cInclude("raylib.h");
    @cDefine("RAYGUI_IMPLEMENTATION", {});
    @cInclude("raygui.h"); // Required for GUI controls
});

pub fn main() void
{
    const screen_width = 800;
    const screen_height = 450;

    c.InitWindow(screen_width, screen_height, "raylib [shapes] example - draw ring");
    defer c.CloseWindow(); // Close window and OpenGL context

    const center = c.Vector2{ .x = @floatFromInt(f32, c.GetScreenWidth() - 300) / 2.0, .y = @floatFromInt(f32, c.GetScreenHeight()) / 2.0 };

    var inner_radius: f32 = 80.0;
    var outer_radius: f32 = 190.0;

    var start_angle: f32 = 0.0;
    var end_angle: f32 = 360.0;
    var segments: f32 = 0.0;

    var draw_ring = true;
    var draw_ring_lines = false;
    var draw_circle_lines = false;

    c.SetTargetFPS(60);

    while (!c.WindowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        // NOTE: All variables update happens inside GUI control functions
        //----------------------------------------------------------------------------------

        // Draw
        //---------------------------------------------------------------------------------
        c.BeginDrawing();
        defer c.EndDrawing();

        c.ClearBackground(c.RAYWHITE);

        c.DrawLine(500, 0, 500, c.GetScreenHeight(), c.Fade(c.LIGHTGRAY, 0.6));
        c.DrawRectangle(500, 0, c.GetScreenWidth() - 500, c.GetScreenHeight(), c.Fade(c.LIGHTGRAY, 0.3));

        if (draw_ring)
            c.DrawRing(center, inner_radius, outer_radius, start_angle, end_angle,
                       @intFromFloat(c_int, segments), c.Fade(c.MAROON, 0.3));
        if (draw_ring_lines)
            c.DrawRingLines(center, inner_radius, outer_radius, start_angle, end_angle,
                            @intFromFloat(c_int, segments), c.Fade(c.BLACK, 0.4));
        if (draw_circle_lines)
            c.DrawCircleSectorLines(center, outer_radius, start_angle, end_angle,
                                    @intFromFloat(c_int, segments), c.Fade(c.BLACK, 0.4));

        // Draw GUI controls
        //------------------------------------------------------------------------------
        _ = c.GuiSliderBar(.{ .x = 600, .y = 40, .width = 120, .height = 20 }, "StartAngle", null, &start_angle, -450, 450);
        _ = c.GuiSliderBar(.{ .x = 600.0, .y = 70.0, .width = 120.0, .height = 20.0 }, "EndAngle", null, &end_angle, -450, 450);

        _ = c.GuiSliderBar(.{ .x = 600.0, .y = 140.0, .width = 120.0, .height = 20.0 }, "InnerRadius", null, &inner_radius, 0, 100);
        _ = c.GuiSliderBar(.{ .x = 600.0, .y = 170.0 , .width = 120.0, .height = 20.0 }, "OuterRadius", null, &outer_radius, 0, 200);

        _ = c.GuiSliderBar(.{ .x = 600.0, .y = 240.0, .width = 120.0, .height = 20.0 },
                           "Segments", null, &segments, 0, 100);

        _ = c.GuiCheckBox(.{ .x = 600, .y = 320, .width = 20, .height = 20 }, "Draw Ring", &draw_ring);
        _ = c.GuiCheckBox(.{ .x = 600, .y = 350, .width = 20, .height = 20 }, "Draw RingLines", &draw_ring_lines);
        _ = c.GuiCheckBox(.{ .x = 600, .y = 380, .width = 20, .height = 20 }, "Draw CircleLines", &draw_circle_lines);
        //------------------------------------------------------------------------------

        var min_segments: i32 = @intFromFloat(i32, @ceil((end_angle - start_angle) / 90.0));
        c.DrawText(c.TextFormat("MODE: %s", @ptrCast([*c]const u8,
                                            if (@intFromFloat(i32, segments) >= min_segments) "MANUAL" else "AUTO")),
                   600, 270, 10, if (@intFromFloat(i32, segments) >= min_segments) c.MAROON else c.DARKGRAY);

        c.DrawFPS(10, 10);
        //---------------------------------------------------------------------------------
    }
}
