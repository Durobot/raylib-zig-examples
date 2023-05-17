// build with `zig build-exe main.zig -lc -lraylib`

// This is a Zig version of a raylib example from
// https://github.com/raysan5/raylib/
// It is distributed under the same license as the original - unmodified zlib/libpng license
// Header from the original source code follows below:

///*******************************************************************************************
//*
//*   raylib [text] example - Font filters
//*
//*   NOTE: After font loading, font texture atlas filter could be configured for a softer
//*   display of the font when scaling it to different sizes, that way, it's not required
//*   to generate multiple fonts at multiple sizes (as long as the scaling is not very different)
//*
//*   Example originally created with raylib 1.3, last time updated with raylib 4.2
//*
//*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//*   BSD-like license that allows static linking with closed source software
//*
//*   Copyright (c) 2015-2023 Ramon Santamaria (@raysan5)
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

    c.InitWindow(screen_width, screen_height, "raylib [text] example - font filters");
    defer c.CloseWindow(); // Close window and OpenGL context

    const msg: [*:0]const u8 = "Loaded Font";

    // NOTE: Textures MUST be loaded after Window initialization (OpenGL context is required)

    // TTF Font loading with custom generation parameters
    var font = c.LoadFontEx("resources/KAISG.ttf", 96, 0, 0); // c.Font
    defer c.UnloadFont(font);

    // Generate mipmap levels to use trilinear filtering
    // NOTE: On 2D drawing it won't be noticeable, it looks like FILTER_BILINEAR
    c.GenTextureMipmaps(&font.texture);

    var font_size = @intToFloat(f32, font.baseSize);
    var font_pos = c.Vector2{ .x = 40.0, .y = screen_height / 2.0 - 80.0 };
    var text_size = c.Vector2{ .x = 0.0, .y = 0.0 };

    // Setup texture scaling filter
    c.SetTextureFilter(font.texture, c.TEXTURE_FILTER_POINT);
    var curr_font_filter = c.TEXTURE_FILTER_POINT;

    c.SetTargetFPS(60);

    while (!c.WindowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        font_size += c.GetMouseWheelMove() * 4.0;

        // Choose font texture filter method
        if (c.IsKeyPressed(c.KEY_ONE))
        {
            c.SetTextureFilter(font.texture, c.TEXTURE_FILTER_POINT);
            curr_font_filter = c.TEXTURE_FILTER_POINT;
        }
        else if (c.IsKeyPressed(c.KEY_TWO))
        {
            c.SetTextureFilter(font.texture, c.TEXTURE_FILTER_BILINEAR);
            curr_font_filter = c.TEXTURE_FILTER_BILINEAR;
        }
        else if (c.IsKeyPressed(c.KEY_THREE))
        {
            // NOTE: Trilinear filter won't be noticed on 2D drawing
            c.SetTextureFilter(font.texture, c.TEXTURE_FILTER_TRILINEAR);
            curr_font_filter = c.TEXTURE_FILTER_TRILINEAR;
        }

        text_size = c.MeasureTextEx(font, msg, font_size, 0);

        if (c.IsKeyDown(c.KEY_LEFT))
        {   font_pos.x -= 10;   }
        else
            if (c.IsKeyDown(c.KEY_RIGHT))
                font_pos.x += 10;

        // Load a dropped TTF file dynamically (at current font_size)
        if (c.IsFileDropped())
        {
            const droppedFiles = c.LoadDroppedFiles(); // c.FilePathList

            // NOTE: We only support first ttf file dropped
            if (c.IsFileExtension(droppedFiles.paths[0], ".ttf"))
            {
                c.UnloadFont(font);
                font = c.LoadFontEx(droppedFiles.paths[0], @floatToInt(c_int, font_size), 0, 0);
            }

            c.UnloadDroppedFiles(droppedFiles);    // Unload filepaths from memory
        }
        //----------------------------------------------------------------------------------

        // Draw
        //---------------------------------------------------------------------------------
        c.BeginDrawing();
        defer c.EndDrawing();

        c.ClearBackground(c.RAYWHITE);

        c.DrawText("Use mouse wheel to change font size", 20, 20, 10, c.GRAY);
        c.DrawText("Use KEY_RIGHT and KEY_LEFT to move text", 20, 40, 10, c.GRAY);
        c.DrawText("Use 1, 2, 3 to change texture filter", 20, 60, 10, c.GRAY);
        c.DrawText("Drop a new TTF font for dynamic loading", 20, 80, 10, c.DARKGRAY);

        c.DrawTextEx(font, msg, font_pos, font_size, 0, c.BLACK);

        // TODO: It seems texSize measurement is not accurate due to chars offsets...
        //DrawRectangleLines(font_pos.x, font_pos.y, text_size.x, text_size.y, RED);

        c.DrawRectangle(0, screen_height - 80, screen_width, 80, c.LIGHTGRAY);
        c.DrawText(c.TextFormat("Font size: %02.02f", text_size), 20, screen_height - 50, 10, c.DARKGRAY);
        c.DrawText(c.TextFormat("Text size: [%02.02f, %02.02f]", text_size.x, text_size.y),
                   20, screen_height - 30, 10, c.DARKGRAY);
        c.DrawText("CURRENT TEXTURE FILTER:", 250, 400, 20, c.GRAY);

        if (curr_font_filter == 0)
        {   c.DrawText("POINT", 570, 400, 20, c.BLACK);   }
        else
            if (curr_font_filter == 1)
            {   c.DrawText("BILINEAR", 570, 400, 20, c.BLACK);   }
            else
                if (curr_font_filter == 2)
                    c.DrawText("TRILINEAR", 570, 400, 20, c.BLACK);
        //---------------------------------------------------------------------------------
    }
}
