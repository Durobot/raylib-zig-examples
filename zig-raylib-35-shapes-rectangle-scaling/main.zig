// build with `zig build-exe main.zig -lc -lraylib`

// This is a Zig version of a raylib example from
// https://github.com/raysan5/raylib/
// It is distributed under the same license as the original - unmodified zlib/libpng license
// Header from the original source code follows below:

///*******************************************************************************************
//*
//*   raylib [shapes] example - rectangle scaling by mouse
//*
//*   Example originally created with raylib 2.5, last time updated with raylib 2.5
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
    const mouse_scale_mark_size = 12;

    c.InitWindow(screen_width, screen_height, "raylib [shapes] example - rectangle scaling mouse");
    defer c.CloseWindow(); // Close window and OpenGL context

    var rec = c.Rectangle{ .x = 100.0, .y = 100.0, .width = 200.0, .height = 80.0 };
    var mouse_pos = c.Vector2{ .x = 0.0, .y = 0.0 };

    var mouse_scale_ready = false;
    var mouse_scale_mode = false;

    c.SetTargetFPS(60);

    while (!c.WindowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        mouse_pos = c.GetMousePosition();

        if (c.CheckCollisionPointRec(mouse_pos,
            .{ .x = rec.x + rec.width - mouse_scale_mark_size,
               .y = rec.y + rec.height - mouse_scale_mark_size,
               .width = mouse_scale_mark_size,
               .height = mouse_scale_mark_size }))
        {
            mouse_scale_ready = true;
            if (c.IsMouseButtonPressed(c.MOUSE_BUTTON_LEFT))
                mouse_scale_mode = true;
        }
        else
            mouse_scale_ready = false;

        if (mouse_scale_mode)
        {
            mouse_scale_ready = true;

            rec.width = mouse_pos.x - rec.x;
            rec.height = mouse_pos.y - rec.y;

            // Check minimum rec size
            if (rec.width < mouse_scale_mark_size)
                rec.width = mouse_scale_mark_size;
            if (rec.height < mouse_scale_mark_size)
                rec.height = mouse_scale_mark_size;

            // Check maximum rec size
            if (rec.width > (@as(f32, @floatFromInt(c.GetScreenWidth())) - rec.x))
                rec.width = @as(f32, @floatFromInt(c.GetScreenWidth())) - rec.x;
            if (rec.height > (@as(f32, @floatFromInt(c.GetScreenHeight())) - rec.y))
                rec.height = @as(f32, @floatFromInt(c.GetScreenHeight())) - rec.y;

            if (c.IsMouseButtonReleased(c.MOUSE_BUTTON_LEFT))
                mouse_scale_mode = false;
        }
        //----------------------------------------------------------------------------------

        // Draw
        //---------------------------------------------------------------------------------
        c.BeginDrawing();
        defer c.EndDrawing();

        c.ClearBackground(c.RAYWHITE);

        c.DrawText("Scale rectangle dragging from bottom-right corner!", 10, 10, 20, c.GRAY);
        c.DrawRectangleRec(rec, c.Fade(c.GREEN, 0.5));

        if (mouse_scale_ready)
        {
            c.DrawRectangleLinesEx(rec, 1, c.RED);
            c.DrawTriangle(.{ .x = rec.x + rec.width - mouse_scale_mark_size, .y = rec.y + rec.height },
                           .{ .x = rec.x + rec.width, .y = rec.y + rec.height },
                           .{ .x = rec.x + rec.width, .y = rec.y + rec.height - mouse_scale_mark_size }, c.RED);
        }
        //---------------------------------------------------------------------------------
    }
}
