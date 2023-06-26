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
    const max_input_chars = 9;

    c.InitWindow(screen_width, screen_height, "raylib [text] example - input box");
    defer c.CloseWindow(); // Close window and OpenGL context

    // NOTE: One extra space required for null terminator char '\0'
    var name = [_]u8{ 0 } ** (max_input_chars + 1);
    var letter_count: usize = 0;

    const text_box = c.Rectangle{ .x = screen_width / 2.0 - 100.0, .y = 180.0,
                                  .width = 225.0, .height = 50.0 };
    var mouse_on_text = false;

    var frames_counter: usize = 0;

    c.SetTargetFPS(10); // Set our game to run at 10 frames-per-second

    while (!c.WindowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        if (c.CheckCollisionPointRec(c.GetMousePosition(), text_box))
        {   mouse_on_text = true;   }
        else
            mouse_on_text = false;

        if (mouse_on_text)
        {
            // Set the window's cursor to the I-Beam
            c.SetMouseCursor(c.MOUSE_CURSOR_IBEAM);

            // Get char pressed (unicode character) on the queue
            var key = c.GetCharPressed();

            // Check if more characters have been pressed on the same frame
            while (key > 0)
            {
                // NOTE: Only allow keys in range [32..125]
                if ((key >= 32) and (key <= 125) and (letter_count < max_input_chars))
                {
                    name[letter_count] = @intCast(u8, key);
                    name[letter_count + 1] = '\x00'; // Add null terminator at the end of the string.
                    letter_count += 1;
                }

                key = c.GetCharPressed();  // Check next character in the queue
            }

            if (c.IsKeyPressed(c.KEY_BACKSPACE))
            {
                //letter_count -= 1;
                //if (letter_count < 0)
                //    letter_count = 0;
                // We want letter_count to be usize, since it's used to index in name array.
                // Because of this, the logic has to be changed - we can't decrement first,
                // check if letter_count is below 0 later, since letter_count is unsigned.
                if (letter_count > 0)
                    letter_count -= 1;
                name[letter_count] = '\x00';
            }
        }
        else c.SetMouseCursor(c.MOUSE_CURSOR_DEFAULT);

        if (mouse_on_text)
        {   frames_counter += 1;   }
        else
            frames_counter = 0;
        //----------------------------------------------------------------------------------

        // Draw
        //---------------------------------------------------------------------------------
        c.BeginDrawing();
        defer c.EndDrawing();

        c.ClearBackground(c.RAYWHITE);

        c.DrawText("PLACE MOUSE OVER INPUT BOX!", 240, 140, 20, c.GRAY);

        c.DrawRectangleRec(text_box, c.LIGHTGRAY);
        if (mouse_on_text)
        {
            c.DrawRectangleLines(@intFromFloat(c_int, text_box.x), @intFromFloat(c_int, text_box.y),
                                 @intFromFloat(c_int, text_box.width), @intFromFloat(c_int, text_box.height),
                                 c.RED);
        }
        else
            c.DrawRectangleLines(@intFromFloat(c_int, text_box.x), @intFromFloat(c_int, text_box.y),
                                 @intFromFloat(c_int, text_box.width), @intFromFloat(c_int, text_box.height),
                                 c.DARKGRAY);

        c.DrawText(&name, @intFromFloat(c_int, text_box.x) + 5, @intFromFloat(c_int, text_box.y) + 8, 40, c.MAROON);

        c.DrawText(c.TextFormat("INPUT CHARS: %i/%i", letter_count, @as(i32, max_input_chars)), 315, 250, 20, c.DARKGRAY);

        if (mouse_on_text)
        {
            if (letter_count < max_input_chars)
            {
                // Draw blinking underscore char
                if (((frames_counter/20)%2) == 0)
                    c.DrawText("_", @intFromFloat(c_int, text_box.x) + 8 + c.MeasureText(&name, 40),
                               @intFromFloat(c_int, text_box.y) + 12, 40, c.MAROON);
            }
            else
                c.DrawText("Press BACKSPACE to delete chars...", 230, 300, 20, c.GRAY);
        }
        //---------------------------------------------------------------------------------
    }
}
