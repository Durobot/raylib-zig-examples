// build with `zig build-exe main.zig -lc -lraylib`

// This is a Zig version of a raylib example from
// https://github.com/raysan5/raylib/
// It is distributed under the same license as the original - unmodified zlib/libpng license
// Header from the original source code follows below:

///*******************************************************************************************
//*
//*   raylib [textures] example - Procedural images generation
//*
//*   Example originally created with raylib 1.8, last time updated with raylib 1.8
//*
//*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//*   BSD-like license that allows static linking with closed source software
//*
//*   Copyright (c) 2O17-2023 Wilhem Barbier (@nounoursheureux) and Ramon Santamaria (@raysan5)
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
    const num_textures = 6; // Currently we have 7 generation algorithms

    c.InitWindow(screen_width, screen_height, "raylib [textures] example - procedural images generation");
    defer c.CloseWindow(); // Close window and OpenGL context

    const vertical_gradient = if (c.RAYLIB_VERSION_MAJOR >= 5) // - Raylib v5.0 works
            c.GenImageGradientLinear(screen_width, screen_height, 0, c.RED, c.BLUE) // c.Image
        else // - Raylib v4.5 is supported, older version may work, but no promises
            c.GenImageGradientV(screen_width, screen_height, c.RED, c.BLUE); // c.Image

    const horizontal_gradient = if (c.RAYLIB_VERSION_MAJOR >= 5) // - Raylib v5.0 works
            c.GenImageGradientLinear(screen_width, screen_height, 0, c.RED, c.BLUE) // c.Image
        else // - Raylib v4.5 is supported, older version may work, but no promises
            c.GenImageGradientH(screen_width, screen_height, c.RED, c.BLUE); // c.Image

    const radial_gradient = c.GenImageGradientRadial(screen_width, screen_height, 0.0, c.WHITE, c.BLACK);
    const checked = c.GenImageChecked(screen_width, screen_height, 32, 32, c.RED, c.BLUE);
    const white_noise = c.GenImageWhiteNoise(screen_width, screen_height, 0.5);
    const cellular = c.GenImageCellular(screen_width, screen_height, 32);

    const textures = [num_textures]c.Texture2D
    {
        c.LoadTextureFromImage(vertical_gradient),
        c.LoadTextureFromImage(horizontal_gradient),
        c.LoadTextureFromImage(radial_gradient),
        c.LoadTextureFromImage(checked),
        c.LoadTextureFromImage(white_noise),
        c.LoadTextureFromImage(cellular)
    };
    // Unload textures data (GPU VRAM)
    defer for (textures) |texture| c.UnloadTexture(texture);

    // Unload image data (CPU RAM)
    c.UnloadImage(vertical_gradient);
    c.UnloadImage(horizontal_gradient);
    c.UnloadImage(radial_gradient);
    c.UnloadImage(checked);
    c.UnloadImage(white_noise);
    c.UnloadImage(cellular);

    var current_texture: u32 = 0;

    c.SetTargetFPS(60); // Set our game to run at 60 frames-per-second

    while (!c.WindowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        if (c.IsMouseButtonPressed(c.MOUSE_BUTTON_LEFT) or c.IsKeyPressed(c.KEY_RIGHT))
            current_texture = (current_texture + 1) % num_textures; // Cycle between the textures
        //----------------------------------------------------------------------------------

        // Draw
        //---------------------------------------------------------------------------------
        c.BeginDrawing();
        defer c.EndDrawing();

        c.ClearBackground(c.RAYWHITE);

        c.DrawTexture(textures[current_texture], 0, 0, c.WHITE);

        c.DrawRectangle(30, 400, 325, 30, c.Fade(c.SKYBLUE, 0.5));
        c.DrawRectangleLines(30, 400, 325, 30, c.Fade(c.WHITE, 0.5));
        c.DrawText("MOUSE LEFT BUTTON to CYCLE PROCEDURAL TEXTURES", 40, 410, 10, c.WHITE);

        switch (current_texture)
        {
            0 => c.DrawText("VERTICAL GRADIENT", 560, 10, 20, c.RAYWHITE),
            1 => c.DrawText("HORIZONTAL GRADIENT", 540, 10, 20, c.RAYWHITE),
            2 => c.DrawText("RADIAL GRADIENT", 580, 10, 20, c.LIGHTGRAY),
            3 => c.DrawText("CHECKED", 680, 10, 20, c.RAYWHITE),
            4 => c.DrawText("WHITE NOISE", 640, 10, 20, c.RED),
            5 => c.DrawText("CELLULAR", 670, 10, 20, c.RAYWHITE),
            else => {}
        }
        //---------------------------------------------------------------------------------
    }
}
