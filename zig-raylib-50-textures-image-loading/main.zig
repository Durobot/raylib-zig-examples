// build with `zig build-exe main.zig -lc -lraylib`

// This is a Zig version of a raylib example from
// https://github.com/raysan5/raylib/
// It is distributed under the same license as the original - unmodified zlib/libpng license
// Header from the original source code follows below:

///*******************************************************************************************
//*
//*   raylib [textures] example - Image loading and texture creation
//*
//*   NOTE: Images are loaded in CPU memory (RAM); textures are loaded in GPU memory (VRAM)
//*
//*   Example originally created with raylib 1.3, last time updated with raylib 1.3
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

    c.InitWindow(screen_width, screen_height, "raylib [textures] example - image loading");
    defer c.CloseWindow(); // Close window and OpenGL context

    // NOTE: Textures MUST be loaded after Window initialization (OpenGL context is required)
    const image = c.LoadImage("resources/raylib_logo.png"); // Loaded in CPU memory (RAM) - c.Image
    const texture = c.LoadTextureFromImage(image); // Image converted to texture, GPU memory (VRAM) - c.Texture2D
    defer c.UnloadTexture(texture); // Texture unloading
    c.UnloadImage(image); // Once image has been converted to texture and uploaded to VRAM, it can be unloaded from RAM

    // Do we really need this? We're displaying a static image.. Oh well.
    c.SetTargetFPS(60); // Set our game to run at 60 frames-per-second

    while (!c.WindowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        //----------------------------------------------------------------------------------

        // Draw
        //---------------------------------------------------------------------------------
        c.BeginDrawing();
        defer c.EndDrawing();

        c.ClearBackground(c.RAYWHITE);

        c.DrawTexture(texture, screen_width/2 - @divTrunc(texture.width, 2),
                      screen_height/2 - @divTrunc(texture.height, 2), c.WHITE);
        c.DrawText("this IS a texture loaded from an image!", 300, 370, 10, c.GRAY);
        //---------------------------------------------------------------------------------
    }
}
