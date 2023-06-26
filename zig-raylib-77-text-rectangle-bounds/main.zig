// build with `zig build-exe main.zig -lc -lraylib`

// This is a Zig version of a raylib example from
// https://github.com/raysan5/raylib/
// It is distributed under the same license as the original - unmodified zlib/libpng license
// Header from the original source code follows below:

///*******************************************************************************************
//*
//*   raylib [text] example - Rectangle bounds
//*
//*   Example originally created with raylib 2.5, last time updated with raylib 4.0
//*
//*   Example contributed by Vlad Adrian (@demizdor) and reviewed by Ramon Santamaria (@raysan5)
//*
//*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//*   BSD-like license that allows static linking with closed source software
//*
//*   Copyright (c) 2018-2023 Vlad Adrian (@demizdor) and Ramon Santamaria (@raysan5)
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

    c.InitWindow(screen_width, screen_height, "raylib [text] example - draw text inside a rectangle");
    defer c.CloseWindow(); // Close window and OpenGL context

    const text: [*:0]const u8 = "Text cannot escape\tthis container\t...word wrap also works when active so here's a long text for testing.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Nec ullamcorper sit amet risus nullam eget felis eget.";

    var resizing = false;
    var word_wrap = true;

    var container = c.Rectangle
    {
        .x = 25.0, .y = 25.0,
        .width = screen_width - 50.0, .height = screen_height - 250.0
    };
    var resizer = c.Rectangle
    {
        .x = container.x + container.width - 17.0,
        .y = container.y + container.height - 17.0,
        .width = 14.0, .height = 14.0
    };

    // Minimum width and heigh for the container rectangle
    const min_width = 60.0;
    const min_height = 60.0;
    const max_width = screen_width - 50.0;
    const max_height = screen_height - 160.0;

    var last_mouse = c.Vector2{ .x = 0.0, .y = 0.0 }; // Stores last mouse coordinates
    var border_color: c.Color = c.MAROON;         // Container border color
    const font = c.GetFontDefault();       // Get default system font - c.Font

    c.SetTargetFPS(60); // Set our game to run at 10 frames-per-second

    while (!c.WindowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        if (c.IsKeyPressed(c.KEY_SPACE))
            word_wrap = !word_wrap;

        const mouse = c.GetMousePosition(); // Vector2

        // Check if the mouse is inside the container and toggle border color
        if (c.CheckCollisionPointRec(mouse, container))
        {   border_color = c.Fade(c.MAROON, 0.4);   }
        else
            if (!resizing)
                border_color = c.MAROON;

        // Container resizing logic
        if (resizing)
        {
            if (c.IsMouseButtonReleased(c.MOUSE_BUTTON_LEFT))
                resizing = false;

            const width = container.width + (mouse.x - last_mouse.x);
            container.width = if (width > min_width) (if (width < max_width) width else max_width) else min_width;

            const height = container.height + (mouse.y - last_mouse.y);
            container.height = if (height > min_height) (if (height < max_height) height else max_height) else min_height;
        }
        else
        {
            // Check if we're resizing
            if (c.IsMouseButtonDown(c.MOUSE_BUTTON_LEFT) and c.CheckCollisionPointRec(mouse, resizer))
                resizing = true;
        }

        // Move resizer rectangle properly
        resizer.x = container.x + container.width - 17.0;
        resizer.y = container.y + container.height - 17.0;

        last_mouse = mouse; // Update mouse
        //----------------------------------------------------------------------------------

        // Draw
        //---------------------------------------------------------------------------------
        c.BeginDrawing();
        defer c.EndDrawing();

        c.ClearBackground(c.RAYWHITE);

        c.DrawRectangleLinesEx(container, 3, border_color);    // Draw container border

        // Draw text in container (add some padding)
        DrawTextBoxed(font, text,
                      .{ .x = container.x + 4.0, .y = container.y + 4.0,
                         .width = container.width - 4.0, .height = container.height - 4.0 },
                      20.0, 2.0, word_wrap, c.GRAY);

        c.DrawRectangleRec(resizer, border_color); // Draw the resize box

        // Draw bottom info
        c.DrawRectangle(0, screen_height - 54, screen_width, 54, c.GRAY);
        c.DrawRectangleRec(.{ .x = 382.0, .y = screen_height - 34.0, .width = 12.0, .height = 12.0 }, c.MAROON);

        c.DrawText("Word Wrap: ", 313, screen_height - 115, 20, c.BLACK);
        if (word_wrap)
        {   c.DrawText("ON", 447, screen_height - 115, 20, c.RED);   }
        else
            c.DrawText("OFF", 447, screen_height - 115, 20, c.BLACK);

        c.DrawText("Press [SPACE] to toggle word wrap", 218, screen_height - 86, 20, c.GRAY);
        c.DrawText("Click hold & drag the    to resize the container", 155, screen_height - 38, 20, c.RAYWHITE);
        //---------------------------------------------------------------------------------
    }
}

// Draw text using font inside rectangle limits
fn DrawTextBoxed(font: c.Font, text: [*c]const u8, rec: c.Rectangle,
                 font_size: f32, spacing: f32, word_wrap: bool, tint: c.Color) void
{
    DrawTextBoxedSelectable(font, text, rec, font_size, spacing, word_wrap, tint, 0, 0, c.WHITE, c.WHITE);
}

// Draw text using font inside rectangle limits with support for text selection
fn DrawTextBoxedSelectable(font: c.Font, text: [*c]const u8, rec: c.Rectangle,
                           font_size: f32, spacing: f32, word_wrap: bool, tint: c.Color,
                           arg_select_start: i32, select_length: i32, select_tint: c.Color, select_back_tint: c.Color) void
{
    var select_start = arg_select_start;

    const length = c.TextLength(text); // Total length in bytes of the text, scanned by codepoints in loop

    var text_offset_y: f32 = 0.0; // Offset between lines (on line break '\n')
    var text_offset_x: f32 = 0.0; // Offset X to next character to draw

    const scale_factor = font_size / @floatFromInt(f32, font.baseSize); // Character rectangle scaling factor

    // Word/character wrapping mechanism variables
    const State = enum { MEASURE_STATE, DRAW_STATE };
    var state = if (word_wrap) State.MEASURE_STATE else State.DRAW_STATE;

    var start_line: i32 = -1; // Index where to begin drawing (where a line begins)
    var end_line: i32 = -1;   // Index where to stop drawing (where a line ends)
    var lastk: i32 = -1;      // Holds last value of the character position

    var i: i32 = 0;
    var k: i32 = 0;
    while (i < length) : (i += 1)
    {
        // Original C code increments both i and k in a single for statement:
        // for (int i = 0, k = 0; i < length; i++, k++)
        // Since i is modified in the for loop body (see below), we can't use
        // for (0..length, 0..) |i, k|
        defer k += 1;

        // Get next codepoint from byte string and glyph index in font
        var codepoint_byte_count: c_int = 0;
        const codepoint = c.GetCodepoint(&text[@intCast(usize, i)], &codepoint_byte_count);
        const index = c.GetGlyphIndex(font, codepoint);

        // NOTE: Normally we exit the decoding sequence as soon as a bad byte is found (and return 0x3f)
        // but we need to draw all of the bad bytes using the '?' symbol moving one byte
        if (codepoint == 0x3F)
            codepoint_byte_count = 1;
        i += codepoint_byte_count - 1;

        var glyph_width: f32 = 0.0;
        if (codepoint != '\n')
        {
            glyph_width = if (font.glyphs[@intCast(usize, index)].advanceX == 0)
                              font.recs[@intCast(usize, index)].width * scale_factor
                          else
                              @floatFromInt(f32, font.glyphs[@intCast(usize, index)].advanceX) * scale_factor;
            if (i + 1 < length)
                glyph_width += spacing;
        }

        // NOTE: When wordWrap is ON we first measure how much of the text we can draw before going outside of the rec container
        // We store this info in startLine and endLine, then we change states, draw the text between those two variables
        // and change states again and again recursively until the end of the text (or until we get outside of the container).
        // When wordWrap is OFF we don't need the measure state so we go to the drawing state immediately
        // and begin drawing on the next line before we can get outside the container.
        if (state == State.MEASURE_STATE)
        {
            // TODO: There are multiple types of spaces in UNICODE, maybe it's a good idea to add support for more
            // Ref: http://jkorpela.fi/chars/spaces.html
            if ((codepoint == ' ') or (codepoint == '\t') or (codepoint == '\n'))
                end_line = i;

            if ((text_offset_x + glyph_width) > rec.width)
            {
                if (end_line < 1) //end_line = if (end_line < 1)  i else end_line; - why?
                    end_line = i;
                if (i == end_line)
                    end_line -= codepoint_byte_count;
                if ((start_line + codepoint_byte_count) == end_line)
                    end_line = i - codepoint_byte_count;

                state = State.DRAW_STATE;
            }
            else
                if ((i + 1) == length)
                {
                    end_line = i;
                    state = State.DRAW_STATE;
                }
                else
                    if (codepoint == '\n')
                        state = State.DRAW_STATE;

            if (state == State.DRAW_STATE)
            {
                text_offset_x = 0.0;
                i = start_line;
                glyph_width = 0.0;

                // Save character position when we switch states
                const tmp = lastk;
                lastk = k - 1;
                k = tmp;
            }
        }
        else // !if (state == State.MEASURE_STATE)
        {
            if (codepoint == '\n')
            {
                if (!word_wrap)
                {
                    text_offset_y += @floatFromInt(f32, (font.baseSize + @divTrunc(font.baseSize, 2))) * scale_factor;
                    text_offset_x = 0.0;
                }
            }
            else
            {
                if (!word_wrap and ((text_offset_x + glyph_width) > rec.width))
                {
                    text_offset_y += @floatFromInt(f32, (font.baseSize + @divTrunc(font.baseSize, 2))) * scale_factor;
                    text_offset_x = 0.0;
                }

                // When text overflows rectangle height limit, just stop drawing
                if ((text_offset_y + @floatFromInt(f32, font.baseSize) * scale_factor) > rec.height)
                    break;

                // Draw selection background
                var is_glyph_selected = false;
                if ((select_start >= 0) and (k >= select_start) and (k < (select_start + select_length)))
                {
                    c.DrawRectangleRec(.{ .x =  rec.x + text_offset_x - 1.0, .y = rec.y + text_offset_y,
                                       .width = glyph_width, .height = @floatFromInt(f32, font.baseSize) * scale_factor },
                                       select_back_tint);
                    is_glyph_selected = true;
                }

                // Draw current character glyph
                if ((codepoint != ' ') and (codepoint != '\t'))
                    c.DrawTextCodepoint(font, codepoint,
                                        .{ .x = rec.x + text_offset_x, .y = rec.y + text_offset_y },
                                        font_size, if (is_glyph_selected) select_tint else tint);
            }

            if (word_wrap and (i == end_line))
            {
                text_offset_y += @floatFromInt(f32, (font.baseSize + @divTrunc(font.baseSize, 2))) * scale_factor;
                text_offset_x = 0.0;
                start_line = end_line;
                end_line = -1;
                glyph_width = 0.0;
                select_start += lastk - k;
                k = lastk;

                state = State.MEASURE_STATE;
            }
        } // !if (state == State.MEASURE_STATE)

        if ((text_offset_x != 0.0) or (codepoint != ' '))
            text_offset_x += glyph_width;  // avoid leading spaces
    }
}
