// build with `zig build-exe main.zig -lc -lraylib`

// This is a Zig version of a raylib example from
// https://github.com/raysan5/raylib/
// It is distributed under the same license as the original - unmodified zlib/libpng license
// Header from the original source code follows below:

///*******************************************************************************************
//*
//*   raylib [text] example - Font loading
//*
//*   NOTE: raylib can load fonts from multiple input file formats:
//*
//*     - TTF/OTF > Sprite font atlas is generated on loading, user can configure
//*                 some of the generation parameters (size, characters to include)
//*     - BMFonts > Angel code font fileformat, sprite font image must be provided
//*                 together with the .fnt file, font generation cna not be configured
//*     - XNA Spritefont > Sprite font image, following XNA Spritefont conventions,
//*                 Characters in image must follow some spacing and order rules
//*
//*   Example originally created with raylib 1.4, last time updated with raylib 3.0
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

    c.InitWindow(screen_width, screen_height, "raylib [text] example - font loading");
    defer c.CloseWindow(); // Close window and OpenGL context

    // Define characters to draw
    // NOTE: raylib supports UTF-8 encoding, following list is actually codified as UTF8 internally
    const msg: [*:0]const u8 = "!\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHI\nJKLMNOPQRSTUVWXYZ[]^_`abcdefghijklmn\nopqrstuvwxyz{|}~¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓ\nÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷\nøùúûüýþÿ";

    // NOTE: Textures MUST be loaded after Window initialization (OpenGL context is required)

    // BMFont (AngelCode) : Font data and image atlas have been generated using external program
    const font_bm = c.LoadFont("resources/pixantiqua.fnt"); // c.Font
    defer c.UnloadFont(font_bm);

    // TTF font : Font data and atlas are generated directly from TTF
    // NOTE: We define a font base size of 32 pixels tall and up-to 250 characters
    const font_ttf = c.LoadFontEx("resources/pixantiqua.ttf", 32, 0, 250); // c.Font
    defer c.UnloadFont(font_ttf);

    var use_ttf = false;

    c.SetTargetFPS(60);

    while (!c.WindowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        if (c.IsKeyDown(c.KEY_SPACE))
        {   use_ttf = true;   }
        else
            use_ttf = false;
        //----------------------------------------------------------------------------------

        // Draw
        //---------------------------------------------------------------------------------
        c.BeginDrawing();
        defer c.EndDrawing();

        c.ClearBackground(c.RAYWHITE);

        c.DrawText("Hold SPACE to use TTF generated font", 20, 20, 20, c.LIGHTGRAY);

        if (!use_ttf)
        {
            c.DrawTextEx(font_bm, msg, .{ .x = 20.0, .y = 100.0 },
                         @intToFloat(f32, font_bm.baseSize), 2, c.MAROON);
            c.DrawText("Using BMFont (Angelcode) imported", 20, c.GetScreenHeight() - 30, 20, c.GRAY);
        }
        else
        {
            c.DrawTextEx(font_ttf, msg, .{ .x = 20.0, .y = 100.0 },
                         @intToFloat(f32, font_ttf.baseSize), 2, c.LIME);
            c.DrawText("Using TTF font generated", 20, c.GetScreenHeight() - 30, 20, c.GRAY);
        }
        //---------------------------------------------------------------------------------
    }
}
