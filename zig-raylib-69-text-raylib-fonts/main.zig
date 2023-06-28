// build with `zig build-exe main.zig -lc -lraylib`

// This is a Zig version of a raylib example from
// https://github.com/raysan5/raylib/
// It is distributed under the same license as the original - unmodified zlib/libpng license
// Header from the original source code follows below:

///*******************************************************************************************
//*
//*   raylib [text] example - raylib fonts loading
//*
//*   NOTE: raylib is distributed with some free to use fonts (even for commercial pourposes!)
//*         To view details and credits for those fonts, check raylib license file
//*
//*   Example originally created with raylib 1.7, last time updated with raylib 3.7
//*
//*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//*   BSD-like license that allows static linking with closed source software
//*
//*   Copyright (c) 2017-2023 Ramon Santamaria (@raysan5)
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
    const max_fonts = 8;

    c.InitWindow(screen_width, screen_height, "raylib [text] example - raylib fonts");
    defer c.CloseWindow(); // Close window and OpenGL context

    // NOTE: Textures MUST be loaded after Window initialization (OpenGL context is required)
    const fonts = [max_fonts]c.Font
    {
        c.LoadFont("resources/fonts/alagard.png"),
        c.LoadFont("resources/fonts/pixelplay.png"),
        c.LoadFont("resources/fonts/mecha.png"),
        c.LoadFont("resources/fonts/setback.png"),
        c.LoadFont("resources/fonts/romulus.png"),
        c.LoadFont("resources/fonts/pixantiqua.png"),
        c.LoadFont("resources/fonts/alpha_beta.png"),
        c.LoadFont("resources/fonts/jupiter_crash.png")
    };
    defer
    {
        for (fonts) |font|
            c.UnloadFont(font);
    }

    const messages = [max_fonts][*:0]const u8
    {
        "ALAGARD FONT designed by Hewett Tsoi",
        "PIXELPLAY FONT designed by Aleksander Shevchuk",
        "MECHA FONT designed by Captain Falcon",
        "SETBACK FONT designed by Brian Kent (AEnigma)",
        "ROMULUS FONT designed by Hewett Tsoi",
        "PIXANTIQUA FONT designed by Gerhard Grossmann",
        "ALPHA_BETA FONT designed by Brian Kent (AEnigma)",
        "JUPITER_CRASH FONT designed by Brian Kent (AEnigma)"
    };

    const spacings = [max_fonts]u32{ 2, 4, 8, 4, 3, 4, 4, 1 };

    var positions: [max_fonts]c.Vector2 = .{}; // initialize with default values

    for (&positions, fonts, messages, spacings, 0..) |*pos, font, msg, spacing, i|
    {
        pos.x = @as(f32, @floatFromInt(screen_width)) / 2.0 -
                c.MeasureTextEx(font, msg,
                                @as(f32, @floatFromInt(font.baseSize)) * 2.0,
                                @floatFromInt(spacing)).x / 2.0;
        pos.y = 60.0 + @as(f32, @floatFromInt(font.baseSize)) + 45.0 * @as(f32, @floatFromInt(i));
    }

    // Small Y position corrections
    positions[3].y += 8.0;
    positions[4].y += 2.0;
    positions[7].y -= 8.0;

    const colors = [max_fonts]c.Color{ c.MAROON, c.ORANGE, c.DARKGREEN, c.DARKBLUE, c.DARKPURPLE, c.LIME, c.GOLD, c.RED };

    c.SetTargetFPS(60);

    while (!c.WindowShouldClose())
    {
        // Update
        //----------------------------------------------------------------------------------
        //----------------------------------------------------------------------------------

        // Draw
        //---------------------------------------------------------------------------------
        c.BeginDrawing();
        defer c.EndDrawing();

        c.ClearBackground(c.RAYWHITE);

        c.DrawText("free fonts included with raylib", 250, 20, 20, c.DARKGRAY);
        c.DrawLine(220, 50, 590, 50, c.DARKGRAY);

        for (positions, fonts, messages, spacings, colors) |pos, font, msg, spacing, color|
            c.DrawTextEx(font, msg, pos, @as(f32, @floatFromInt(font.baseSize)) * 2.0, @floatFromInt(spacing), color);
        //---------------------------------------------------------------------------------
    }
}
