// build with `zig build-exe main.zig -lc -lraylib`

// This is a Zig version of a raylib example from
// https://github.com/raysan5/raylib/
// It is distributed under the same license as the original - unmodified zlib/libpng license
// Header from the original source code follows below:

///*******************************************************************************************
//*
//*   raylib [text] example - Sprite font loading
//*
//*   NOTE: Sprite fonts should be generated following this conventions:
//*
//*     - Characters must be ordered starting with character 32 (Space)
//*     - Every character must be contained within the same Rectangle height
//*     - Every character and every line must be separated by the same distance (margin/padding)
//*     - Rectangles must be defined by a MAGENTA color background
//*
//*   Following those constraints, a font can be provided just by an image,
//*   this is quite handy to avoid additional font descriptor files (like BMFonts use).
//*
//*   Example originally created with raylib 1.0, last time updated with raylib 1.0
//*
//*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//*   BSD-like license that allows static linking with closed source software
//*
//*   Copyright (c) 2014-2023 Ramon Santamaria (@raysan5)
//*
//********************************************************************************************/

const std = @import("std");
const c = @cImport(
{
    @cInclude("raylib.h");
});

pub fn main() void
{
    const screen_width = 800;
    const screen_height = 450;

    c.InitWindow(screen_width, screen_height, "raylib [text] example - sprite font loading");
    defer c.CloseWindow(); // Close window and OpenGL context

    const msg1: [*:0]const u8 = "THIS IS A custom SPRITE FONT...";
    const msg2: [*:0]const u8 = "...and this is ANOTHER CUSTOM font...";
    const msg3: [*:0]const u8 = "...and a THIRD one! GREAT! :D";

    // NOTE: Textures MUST be loaded after Window initialization (OpenGL context is required)
    const font1 = c.LoadFont("resources/custom_mecha.png");          // Font loading
    const font2 = c.LoadFont("resources/custom_alagard.png");        // Font loading
    const font3 = c.LoadFont("resources/custom_jupiter_crash.png");  // Font loading
    defer
    {
        c.UnloadFont(font1);
        c.UnloadFont(font2);
        c.UnloadFont(font3);
    }

    const font_pos1 = c.Vector2{ .x = screen_width / 2.0 -
                                  c.MeasureTextEx(font1, msg1, @floatFromInt(font1.baseSize), -3).x / 2.0,
                                 .y = screen_height / 2.0 - @as(f32, @floatFromInt(font1.baseSize)) / 2.0 - 80.0 };

    const font_pos2 = c.Vector2{ .x = screen_width / 2.0 -
                                  c.MeasureTextEx(font2, msg2, @floatFromInt(font2.baseSize), -2.0).x / 2.0,
                                 .y = screen_height / 2.0 - @as(f32, @floatFromInt(font2.baseSize)) / 2.0 - 10.0 };

    const font_pos3 = c.Vector2{ .x = screen_width/2.0 -
                                  c.MeasureTextEx(font3, msg3, @floatFromInt(font3.baseSize), 2.0).x / 2.0,
                                 .y = screen_height/2.0 - @as(f32, @floatFromInt(font3.baseSize)) / 2.0 + 50.0 };

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

        c.DrawTextEx(font1, msg1, font_pos1, @floatFromInt(font1.baseSize), -3, c.WHITE);
        c.DrawTextEx(font2, msg2, font_pos2, @floatFromInt(font2.baseSize), -2, c.WHITE);
        c.DrawTextEx(font3, msg3, font_pos3, @floatFromInt(font3.baseSize), 2, c.WHITE);
        //---------------------------------------------------------------------------------
    }
}
