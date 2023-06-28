// build with `zig build-exe main.zig -lc -lraylib`

// This is a Zig version of a raylib example from
// https://github.com/raysan5/raylib/
// It is distributed under the same license as the original - unmodified zlib/libpng license
// Header from the original source code follows below:

///*******************************************************************************************
//*
//*   raylib [text] example - Input Box
//*
//*   Example originally created with raylib 1.7, last time updated with raylib 3.5
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

    c.InitWindow(screen_width, screen_height, "raylib [text] example - text writing anim");
    defer c.CloseWindow(); // Close window and OpenGL context

    const message: [*:0]const u8 = "This sample illustrates a text writing\nanimation effect! Check it out! ;)";

    var frames_counter: usize = 0;

    c.SetTargetFPS(60); // Set our game to run at 10 frames-per-second

    while (!c.WindowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        if (c.IsKeyDown(c.KEY_SPACE))
        {   frames_counter += 8;   }
        else
            frames_counter += 1;

        if (c.IsKeyPressed(c.KEY_ENTER))
            frames_counter = 0;
        //----------------------------------------------------------------------------------

        // Draw
        //---------------------------------------------------------------------------------
        c.BeginDrawing();
        defer c.EndDrawing();

        c.ClearBackground(c.RAYWHITE);

        // @intCast -> c_int
        c.DrawText(c.TextSubtext(message, 0, @intCast(frames_counter / 10)), 210, 160, 20, c.MAROON);

        c.DrawText("PRESS [ENTER] to RESTART!", 240, 260, 20, c.LIGHTGRAY);
        c.DrawText("PRESS [SPACE] to SPEED UP!", 239, 300, 20, c.LIGHTGRAY);
        //---------------------------------------------------------------------------------
    }
}
