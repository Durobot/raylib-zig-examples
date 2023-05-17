// build with `zig build-exe main.zig -lc -lraylib`

// This is a Zig version of a raylib example from
// https://github.com/raysan5/raylib/
// It is distributed under the same license as the original - unmodified zlib/libpng license
// Header from the original source code follows below:

///*******************************************************************************************
//*
//*   raylib [textures] example - Draw a texture along a segmented curve
//*
//*   Example originally created with raylib 4.5, last time updated with raylib 4.5
//*
//*   Example contributed by Jeffery Myers and reviewed by Ramon Santamaria (@raysan5)
//*
//*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//*   BSD-like license that allows static linking with closed source software
//*
//*   Copyright (c) 2022-2023 Jeffery Myers and Ramon Santamaria (@raysan5)
//*
//********************************************************************************************/

const std = @import("std"); // std.math.pow()
const c = @cImport(
{
    @cInclude("raylib.h");
    @cInclude("raymath.h");
    @cInclude("rlgl.h");
});

var tex_road = c.Texture{ .id = 0, .width = 0, .height = 0, .mipmaps = 0, .format = 0 };

var show_curve = false;

var curve_width: f32 = 50.0;
var curve_segments: u32 = 24;

var curve_start_pos = c.Vector2{ .x = 80.0, .y = 100.0 };
var curve_start_pos_tangent = c.Vector2{ .x = 100.0, .y = 300.0 };

var curve_end_pos = c.Vector2{ .x = 700.0, .y = 350.0 };
var curve_end_pos_tangent = c.Vector2{ .x = 600.0, .y = 100.0 };

var curve_selected_point: ?*c.Vector2 = null;

pub fn main() void
{
    const screen_width = 800;
    const screen_height = 450;

    c.SetConfigFlags(c.FLAG_VSYNC_HINT | c.FLAG_MSAA_4X_HINT);
    c.InitWindow(screen_width, screen_height, "raylib [textures] examples - textured curve");
    defer c.CloseWindow(); // Close window and OpenGL context

    // Load the road texture
    tex_road = c.LoadTexture("resources/road.png");
    defer c.UnloadTexture(tex_road);
    c.SetTextureFilter(tex_road, c.TEXTURE_FILTER_BILINEAR);

    c.SetTargetFPS(60);

    while (!c.WindowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        UpdateCurve();
        UpdateOptions();
        //----------------------------------------------------------------------------------

        // Draw
        //---------------------------------------------------------------------------------
        c.BeginDrawing();
        defer c.EndDrawing();

        c.ClearBackground(c.RAYWHITE);

        DrawTexturedCurve();
        DrawCurve();

        c.DrawText("Drag points to move curve, press SPACE to show/hide base curve", 10, 10, 10, c.DARKGRAY);
        c.DrawText(c.TextFormat("Curve width: %2.0f (Use + and - to adjust)", curve_width), 10, 30, 10, c.DARKGRAY);
        c.DrawText(c.TextFormat("Curve segments: %u (Use LEFT and RIGHT to adjust)", curve_segments), 10, 50, 10, c.DARKGRAY);
        //---------------------------------------------------------------------------------
    }
}

fn DrawCurve() void
{
    if (show_curve)
        c.DrawLineBezierCubic(curve_start_pos, curve_end_pos,
                              curve_start_pos_tangent, curve_end_pos_tangent, 2, c.BLUE);

    // Draw the various control points and highlight where the mouse is
    c.DrawLineV(curve_start_pos, curve_start_pos_tangent, c.SKYBLUE);
    c.DrawLineV(curve_end_pos, curve_end_pos_tangent, c.PURPLE);
    const mouse = c.GetMousePosition(); // Vector2

    if (c.CheckCollisionPointCircle(mouse, curve_start_pos, 6))
        c.DrawCircleV(curve_start_pos, 7, c.YELLOW);
    c.DrawCircleV(curve_start_pos, 5, c.RED);

    if (c.CheckCollisionPointCircle(mouse, curve_start_pos_tangent, 6))
        c.DrawCircleV(curve_start_pos_tangent, 7, c.YELLOW);
    c.DrawCircleV(curve_start_pos_tangent, 5, c.MAROON);

    if (c.CheckCollisionPointCircle(mouse, curve_end_pos, 6))
        c.DrawCircleV(curve_end_pos, 7, c.YELLOW);
    c.DrawCircleV(curve_end_pos, 5, c.GREEN);

    if (c.CheckCollisionPointCircle(mouse, curve_end_pos_tangent, 6))
        c.DrawCircleV(curve_end_pos_tangent, 7, c.YELLOW);
    c.DrawCircleV(curve_end_pos_tangent, 5, c.DARKGREEN);
}

fn DrawTexturedCurve() void
{
    const step = 1.0 / @intToFloat(f32, curve_segments);

    var previous = curve_start_pos;
    var previous_tangent = c.Vector2{ .x = 0.0, .y = 0.0 };
    var previous_v: f32 = 0.0;

    // We can't compute a tangent for the first point, so we need to reuse the tangent from the first segment
    var tangent_set = false;

    var current = c.Vector2{ .x = 0.0, .y = 0.0 };
    var t: f32 = 0.0;

    for (1..curve_segments + 1) |i|
    {
        // Segment the curve
        t = step * @intToFloat(f32, i);
        const one_minus_t = 1.0 - t;
        const a = std.math.pow(f32, one_minus_t, 3.0);
        const b = 3.0 * std.math.pow(f32, one_minus_t, 2.0) * t;
        const cc = 3.0 * one_minus_t * std.math.pow(f32, t, 2.0);
        const d = std.math.pow(f32, t, 3.0);

        // Compute the endpoint for this segment
        current.y = a*curve_start_pos.y + b*curve_start_pos_tangent.y + cc*curve_end_pos_tangent.y + d*curve_end_pos.y;
        current.x = a*curve_start_pos.x + b*curve_start_pos_tangent.x + cc*curve_end_pos_tangent.x + d*curve_end_pos.x;

        // Vector from previous to current
        const delta = c.Vector2{ .x = current.x - previous.x, .y = current.y - previous.y };

        // The right hand normal to the delta vector
        const normal = c.Vector2Normalize(.{ .x = -delta.y, .y = delta.x }); // Vector2

        // The v texture coordinate of the segment (add up the length of all the segments so far)
        const v = previous_v + c.Vector2Length(delta);

        // Make sure the start point has a normal
        if (!tangent_set)
        {
            previous_tangent = normal;
            tangent_set = true;
        }

        // Extend out the normals from the previous and current points to get the quad for this segment
        const prev_pos_normal = c.Vector2Add(previous, c.Vector2Scale(previous_tangent, curve_width)); // Vector2
        const prev_neg_normal = c.Vector2Add(previous, c.Vector2Scale(previous_tangent, -curve_width)); // Vector2

        const current_pos_normal = c.Vector2Add(current, c.Vector2Scale(normal, curve_width)); // Vector2
        const current_neg_normal = c.Vector2Add(current, c.Vector2Scale(normal, -curve_width)); // Vector2

        // Draw the segment as a quad
        c.rlSetTexture(tex_road.id);
        {
            c.rlBegin(c.RL_QUADS);
            defer c.rlEnd();

            c.rlColor4ub(255,255,255,255);
            c.rlNormal3f(0.0, 0.0, 1.0);

            c.rlTexCoord2f(0, previous_v);
            c.rlVertex2f(prev_neg_normal.x, prev_neg_normal.y);

            c.rlTexCoord2f(1, previous_v);
            c.rlVertex2f(prev_pos_normal.x, prev_pos_normal.y);

            c.rlTexCoord2f(1, v);
            c.rlVertex2f(current_pos_normal.x, current_pos_normal.y);

            c.rlTexCoord2f(0, v);
            c.rlVertex2f(current_neg_normal.x, current_neg_normal.y);
        }

        // The current step is the start of the next step
        previous = current;
        previous_tangent = normal;
        previous_v = v;
    }
}


fn UpdateCurve() void
{
    // If the mouse is not down, we are not editing the curve so clear the selection
    if (!c.IsMouseButtonDown(c.MOUSE_LEFT_BUTTON))
    {
        curve_selected_point = null;
        return;
    }

    // If a point was selected, move it
    if (curve_selected_point) |pt_ptr|
    {
        pt_ptr.* = c.Vector2Add(pt_ptr.*, c.GetMouseDelta());
        return;
    }

    // The mouse is down, and nothing was selected, so see if anything was picked
    const mouse_pos = c.GetMousePosition(); // Vector2

    if (c.CheckCollisionPointCircle(mouse_pos, curve_start_pos, 6))
    {   curve_selected_point = &curve_start_pos;   }
    else
    {
        if (c.CheckCollisionPointCircle(mouse_pos, curve_start_pos_tangent, 6))
        {   curve_selected_point = &curve_start_pos_tangent;   }
        else
        {
            if (c.CheckCollisionPointCircle(mouse_pos, curve_end_pos, 6))
            {   curve_selected_point = &curve_end_pos;   }
            else
            {
                if (c.CheckCollisionPointCircle(mouse_pos, curve_end_pos_tangent, 6))
                    curve_selected_point = &curve_end_pos_tangent;
            }
        }
    }
}

fn UpdateOptions() void
{
    if (c.IsKeyPressed(c.KEY_SPACE)) show_curve = !show_curve;

    // Update with
    if (c.IsKeyPressed(c.KEY_EQUAL)) curve_width += 2.0;
    if (c.IsKeyPressed(c.KEY_MINUS)) curve_width -= 2.0;

    if (curve_width < 2.0) curve_width = 2.0;

    // Update segments
    if (c.IsKeyPressed(c.KEY_LEFT)) curve_segments -= 2;
    if (c.IsKeyPressed(c.KEY_RIGHT)) curve_segments += 2;

    if (curve_segments < 2) curve_segments = 2;
}
