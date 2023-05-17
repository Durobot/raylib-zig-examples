// build with `zig build-exe main.zig -lc -lraylib`

// This is a Zig version of a raylib example from
// https://github.com/raysan5/raylib/
// It is distributed under the same license as the original - unmodified zlib/libpng license
// Header from the original source code follows below:

///*******************************************************************************************
//*
//*   raylib [shapes] example - Draw basic shapes 2d (rectangle, circle, line...)
//*
//*   Example originally created with raylib 1.0, last time updated with raylib 4.2
//*
//*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,an5)
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

    c.InitWindow(screen_width, screen_height, "raylib [shapes] example - basic shapes drawing");
    defer c.CloseWindow(); // Close window and OpenGL context

    var rotation: f32 = 0.0;

    c.SetTargetFPS(60);

    while (!c.WindowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        rotation += 0.2;
        //----------------------------------------------------------------------------------

        // Draw
        //---------------------------------------------------------------------------------
        c.BeginDrawing();
        defer c.EndDrawing();

        c.ClearBackground(c.RAYWHITE);

        c.DrawText("some basic shapes available on raylib", 20, 20, 20, c.DARKGRAY);

        // Circle shapes and lines
        c.DrawCircle(screen_width/5, 120, 35, c.DARKBLUE);
        c.DrawCircleGradient(screen_width/5, 220, 60, c.GREEN, c.SKYBLUE);
        c.DrawCircleLines(screen_width/5, 340, 80, c.DARKBLUE);

        // Rectangle shapes and lines
        c.DrawRectangle(screen_width/4*2 - 60, 100, 120, 60, c.RED);
        c.DrawRectangleGradientH(screen_width/4*2 - 90, 170, 180, 130, c.MAROON, c.GOLD);
        c.DrawRectangleLines(screen_width/4*2 - 40, 320, 80, 60, c.ORANGE); // NOTE: Uses QUADS internally, not lines

        // Triangle shapes and lines
        c.DrawTriangle(.{ .x = screen_width/4.0 * 3.0, .y = 80.0 },
                       .{ .x = screen_width/4.0 * 3.0 - 60.0, .y = 150.0 },
                       .{ .x = screen_width/4.0 * 3.0 + 60.0, .y = 150.0 }, c.VIOLET);

        c.DrawTriangleLines(.{ .x = screen_width/4.0 * 3.0, .y = 160.0 },
                            .{ .x = screen_width/4.0 * 3.0 - 20.0, .y = 230.0 },
                            .{ .x = screen_width/4.0 * 3.0 + 20.0, .y = 230.0 }, c.DARKBLUE);

        // Polygon shapes and lines
        c.DrawPoly(.{ .x = screen_width/4.0 * 3, .y = 330 }, 6, 80, rotation, c.BROWN);
        c.DrawPolyLines(.{ .x = screen_width/4.0 * 3, .y = 330 }, 6, 90, rotation, c.BROWN);
        c.DrawPolyLinesEx(.{ .x = screen_width/4.0 * 3, .y = 330 }, 6, 85, rotation, 6, c.BEIGE);

        // NOTE: We draw all LINES based shapes together to optimize internal drawing,
        // this way, all LINES are rendered in a single draw pass
        c.DrawLine(18, 42, screen_width - 18, 42, c.BLACK);
        //---------------------------------------------------------------------------------
    }
}
