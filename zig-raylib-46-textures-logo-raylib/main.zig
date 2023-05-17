// build with `zig build-exe main.zig -lc -lraylib`

// This is a Zig version of a raylib example from
// https://github.com/raysan5/raylib/
// It is distributed under the same license as the original - unmodified zlib/libpng license
// Header from the original source code follows below:

///*******************************************************************************************
//*
//*   raylib [textures] example - Texture loading and drawing
//*
//*   Example originally created with raylib 1.0, last time updated with raylib 1.0
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

    c.InitWindow(screen_width, screen_height, "raylib [textures] example - texture loading and drawing");
    defer c.CloseWindow(); // Close window and OpenGL context

    // NOTE: Textures MUST be loaded after Window initialization (OpenGL context is required)
    const texture = c.LoadTexture("resources/raylib_logo.png"); // c.Texture2D
    defer c.UnloadTexture(texture);

    // c.SetTargetFPS(60); -- Don't need this since we're displaying a static image

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
        c.DrawText("this IS a texture!", 360, 370, 10, c.GRAY);
        //---------------------------------------------------------------------------------
    }
}
