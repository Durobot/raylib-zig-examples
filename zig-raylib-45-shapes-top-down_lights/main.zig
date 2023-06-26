// build with `zig build-exe main.zig -lc -lraylib`

// This is a Zig version of a raylib example from
// https://github.com/raysan5/raylib/
// It is distributed under the same license as the original - unmodified zlib/libpng license
// Header from the original source code follows below:

///*******************************************************************************************
//*
//*   raylib [shapes] example - top down lights
//*
//*   Example originally created with raylib 4.2, last time updated with raylib 4.2
//*
//*   Example contributed by Vlad Adrian (@demizdor) and reviewed by Ramon Santamaria (@raysan5)
//*
//*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//*   BSD-like license that allows static linking with closed source software
//*
//*   Copyright (c) 2022-2023 Jeffery Myers (@JeffM2501)
//*
//********************************************************************************************/

const c = @cImport(
{
    @cInclude("raylib.h");
    @cInclude("raymath.h");
    @cInclude("rlgl.h");
});

// Custom Blend Modes
const rlgl_src_alpha = 0x0302;
const rlgl_min = 0x8007;
const rlgl_max = 0x8008;

const max_boxes = 20;
const max_shadows = max_boxes * 3; // max_boxes *3. Each box can cast up to two shadow volumes for the edges it is away from, and one for the box itself
const max_lights = 16;

// Shadow geometry type
const ShadowGeometry = struct
{
     vertices: [4]c.Vector2,

     fn init() ShadowGeometry
     {
         return .{ .vertices = [_]c.Vector2{ .{ .x = 0.0, .y = 0.0 } } ** 4 };
     }
};

// Light info type
const LightInfo = struct
{
    active: bool,          // Is this light slot active?
    dirty: bool,           // Does this light need to be updated?
    valid: bool,           // Is this light in a valid position?

    position: c.Vector2,   // Light position
    mask: c.RenderTexture, // Alpha mask for the light
    outer_radius: f32,      // The distance the light touches
    bounds: c.Rectangle,   // A cached rectangle of the light bounds to help with culling

    shadows: [max_shadows]ShadowGeometry,
    shadowCount: u32,

    fn init() LightInfo
    {
        return
        .{
            .active = false,
            .dirty = false,
            .valid = false,
            .position = .{ .x = 0.0, .y = 0.0 },
            .mask =
            .{
                .id = 0,
                .texture = .{ .id = 0, .width = 0, .height = 0, .mipmaps = 0, .format = 0  },
                .depth = .{ .id = 0, .width = 0, .height = 0, .mipmaps = 0, .format = 0  }
            },
            .outer_radius = 0,
            .bounds = .{ .x = 0.0, .y = 0.0, .width = 0.0, .height = 0.0 },
            .shadows = [_]ShadowGeometry{ ShadowGeometry.init() } ** max_shadows,
            .shadowCount = 0
        };
    }
};

var lights = [_]LightInfo{ LightInfo.init() } ** max_lights;

pub fn main() void
{
    const screen_width = 800;
    const screen_height = 450;

    c.InitWindow(screen_width, screen_height, "raylib [shapes] example - top down lights");
    defer c.CloseWindow(); // Close window and OpenGL context

    // Initialize our 'world' of boxes
    const box_count = max_boxes; // Why do we need this?
    var boxes: [max_boxes]c.Rectangle = undefined; //= comptime setupBoxes(box_count);
    setupBoxes(boxes[0..max_boxes]);

    // Create a checkerboard ground texture
    const img = c.GenImageChecked(64, 64, 32, 32, c.DARKBROWN, c.DARKGRAY); // c.Image
    const background_texture = c.LoadTextureFromImage(img); // c.Texture2D
    defer c.UnloadTexture(background_texture);
    c.UnloadImage(img);

    // Create a global light mask to hold all the blended lights
    const light_mask = c.LoadRenderTexture(c.GetScreenWidth(), c.GetScreenHeight()); // c.RenderTexture
    defer c.UnloadRenderTexture(light_mask);

    // Setup initial light
    setupLight(0, 600, 400, 300);
    defer
        for (lights) |light|
            if (light.active)
                c.UnloadRenderTexture(light.mask);

    var next_light: u32 = 1;
    var show_lines = false;

    c.SetTargetFPS(60);

    while (!c.WindowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        // Drag light 0
        if (c.IsMouseButtonDown(c.MOUSE_BUTTON_LEFT))
            moveLight(0, c.GetMousePosition().x, c.GetMousePosition().y);

        // Make a new light
        if (c.IsMouseButtonPressed(c.MOUSE_BUTTON_RIGHT) and (next_light < max_lights))
        {
            setupLight(next_light, c.GetMousePosition().x, c.GetMousePosition().y, 200);
            next_light += 1;
        }

        // Toggle debug info
        if (c.IsKeyPressed(c.KEY_F1))
            show_lines = !show_lines;

        // Update the lights and keep track if any were dirty so we know if we need to update the master light mask
        var dirtyLights = false;
        for (0..max_lights) |i|
        {
            if (updateLight(@intCast(u32, i), boxes[0..max_boxes]))
                dirtyLights = true;
        }

        // Update the light mask
        if (dirtyLights)
        {
            // Build up the light mask
            c.BeginTextureMode(light_mask);
            defer c.EndTextureMode();

            c.ClearBackground(c.BLACK);

            // Force the blend mode to only set the alpha of the destination
            c.rlSetBlendFactors(rlgl_src_alpha, rlgl_src_alpha, rlgl_min);
            c.rlSetBlendMode(c.BLEND_CUSTOM);

            // Merge in all the light masks
            for (0..max_lights) |i|
            {
                if (lights[i].active)
                    c.DrawTextureRec(lights[i].mask.texture,
                                     .{ .x = 0, .y = 0,
                                        .width = @floatFromInt(f32, c.GetScreenWidth()), .height = @floatFromInt(f32, -c.GetScreenHeight()) },
                                     c.Vector2Zero(), c.WHITE);
            }

            c.rlDrawRenderBatchActive();

            // Go back to normal blend
            c.rlSetBlendMode(c.BLEND_ALPHA);
        }
        //----------------------------------------------------------------------------------

        // Draw
        //---------------------------------------------------------------------------------
        c.BeginDrawing();
        defer c.EndDrawing();

        c.ClearBackground(c.BLACK);

        // Draw the tile background
        c.DrawTextureRec(background_texture,
                         .{ .x = 0.0, .y = 0.0,
                            .width = @floatFromInt(f32, c.GetScreenWidth()),
                            .height = @floatFromInt(f32, c.GetScreenHeight()) },
                         c.Vector2Zero(), c.WHITE);

        // Overlay the shadows from all the lights
        c.DrawTextureRec(light_mask.texture,
                         .{ .x = 0.0, .y = 0.0,
                            .width = @floatFromInt(f32, c.GetScreenWidth()),
                            .height = @floatFromInt(f32, -c.GetScreenHeight()) },
                         c.Vector2Zero(), c.ColorAlpha(c.WHITE, if (show_lines) 0.75 else 1.0));

        // Draw the lights
        for (0..max_lights) |i|
            if (lights[i].active)
                c.DrawCircle(@intFromFloat(c_int, lights[i].position.x),
                             @intFromFloat(c_int, lights[i].position.y), 10,
                             if (i == 0) c.YELLOW else c.WHITE);

        if (show_lines)
        {
            for (0..lights[0].shadowCount) |s|
                c.DrawTriangleFan(&lights[0].shadows[s].vertices, 4, c.DARKPURPLE);

            for (0..box_count) |b|
            {
                if (c.CheckCollisionRecs(boxes[b], lights[0].bounds))
                    c.DrawRectangleRec(boxes[b], c.PURPLE);

                c.DrawRectangleLines(@intFromFloat(c_int, boxes[b].x), @intFromFloat(c_int, boxes[b].y),
                                     @intFromFloat(c_int, boxes[b].width), @intFromFloat(c_int, boxes[b].height),
                                     c.DARKBLUE);
            }

            c.DrawText("(F1) Hide Shadow Volumes", 10, 50, 10, c.GREEN);
        }
        else
            c.DrawText("(F1) Show Shadow Volumes", 10, 50, 10, c.GREEN);

        c.DrawFPS(screen_width - 80, 10);
        c.DrawText("Drag to move light #1", 10, 10, 10, c.DARKGREEN);
        c.DrawText("Right click to add new light", 10, 30, 10, c.DARKGREEN);
        //---------------------------------------------------------------------------------
    }
}

// Set up some boxes
fn setupBoxes(boxes: []c.Rectangle) void
{
    // boxes.len must be >= 5
    boxes[0] = .{ .x = 150.0,  .y = 80.0,  .width = 40.0, .height = 40.0 };
    boxes[1] = .{ .x = 1200.0, .y = 700.0, .width = 40.0, .height = 40.0 };
    boxes[2] = .{ .x = 200.0,  .y = 600.0, .width = 40.0, .height = 40.0 };
    boxes[3] = .{ .x = 1000.0, .y = 50.0,  .width = 40.0, .height = 40.0 };
    boxes[4] = .{ .x = 500.0,  .y = 350.0, .width = 40.0, .height = 40.0 };

    for (5..boxes.len) |i|
    {
        boxes[i] =
        .{
            .x = @floatFromInt(f32, c.GetRandomValue(0, c.GetScreenWidth())),
            .y = @floatFromInt(f32, c.GetRandomValue(0, c.GetScreenHeight())),
            .width = @floatFromInt(f32, c.GetRandomValue(10, 100)),
            .height = @floatFromInt(f32, c.GetRandomValue(10, 100))
        };
    }
}

// Setup a light
fn setupLight(slot: u32, x: f32, y: f32, radius: f32) void
{
    lights[slot].active = true;
    lights[slot].valid = false;  // The light must prove it is valid
    lights[slot].mask = c.LoadRenderTexture(c.GetScreenWidth(), c.GetScreenHeight());
    lights[slot].outer_radius = radius;

    lights[slot].bounds.width = radius * 2;
    lights[slot].bounds.height = radius * 2;

    moveLight(slot, x, y);

    // Force the render texture to have something in it
    drawLightMask(slot);
}

// Move a light and mark it as dirty so that we update it's mask next frame
fn moveLight(slot: u32, x: f32, y: f32) void
{
    lights[slot].dirty = true;
    lights[slot].position.x = x;
    lights[slot].position.y = y;

    // update the cached bounds
    lights[slot].bounds.x = x - lights[slot].outer_radius;
    lights[slot].bounds.y = y - lights[slot].outer_radius;
}

// See if a light needs to update its mask
fn updateLight(slot: u32, boxes: []c.Rectangle) bool
{
    if (!lights[slot].active or !lights[slot].dirty)
        return false;

    lights[slot].dirty = false;
    lights[slot].shadowCount = 0;
    lights[slot].valid = false;

    for (boxes) |box|
    {
        // Are we in a box? if so we are not valid
        if (c.CheckCollisionPointRec(lights[slot].position, box))
            return false;

        // If this box is outside our bounds, we can skip it
        if (!c.CheckCollisionRecs(lights[slot].bounds, box))
            continue;

        // Check the edges that are on the same side we are, and cast shadow volumes out from them

        // Top
        var sp = c.Vector2{ .x = box.x, .y = box.y };
        var ep = c.Vector2{ .x = box.x + box.width, .y = box.y };

        if (lights[slot].position.y > ep.y)
            computeShadowVolumeForEdge(slot, sp, ep);

        // Right
        sp = ep;
        ep.y += box.height;
        if (lights[slot].position.x < ep.x)
            computeShadowVolumeForEdge(slot, sp, ep);

        // Bottom
        sp = ep;
        ep.x -= box.width;
        if (lights[slot].position.y < ep.y)
            computeShadowVolumeForEdge(slot, sp, ep);

        // Left
        sp = ep;
        ep.y -= box.height;
        if (lights[slot].position.x > ep.x)
            computeShadowVolumeForEdge(slot, sp, ep);

        // The box itself
        lights[slot].shadows[lights[slot].shadowCount].vertices[0] = .{ .x = box.x, .y = box.y };
        lights[slot].shadows[lights[slot].shadowCount].vertices[1] = .{ .x = box.x, .y = box.y + box.height };
        lights[slot].shadows[lights[slot].shadowCount].vertices[2] = .{ .x = box.x + box.width, .y = box.y + box.height };
        lights[slot].shadows[lights[slot].shadowCount].vertices[3] = .{ .x = box.x + box.width, .y = box.y };
        lights[slot].shadowCount += 1;
    }

    lights[slot].valid = true;

    drawLightMask(slot);

    return true;
}

// Compute a shadow volume for the edge
// It takes the edge and projects it back by the light radius and turns it into a quad
fn computeShadowVolumeForEdge(slot: u32, sp: c.Vector2, ep: c.Vector2) void
{
    if (lights[slot].shadowCount >= max_shadows)
        return;

    const extension = lights[slot].outer_radius * 2.0;

    const sp_vector = c.Vector2Normalize(c.Vector2Subtract(sp, lights[slot].position)); // c.Vector2
    const sp_projection = c.Vector2Add(sp, c.Vector2Scale(sp_vector, extension)); // c.Vector2

    const ep_vector = c.Vector2Normalize(c.Vector2Subtract(ep, lights[slot].position)); // c.Vector2
    const ep_projection = c.Vector2Add(ep, c.Vector2Scale(ep_vector, extension)); // c.Vector2

    lights[slot].shadows[lights[slot].shadowCount].vertices[0] = sp;
    lights[slot].shadows[lights[slot].shadowCount].vertices[1] = ep;
    lights[slot].shadows[lights[slot].shadowCount].vertices[2] = ep_projection;
    lights[slot].shadows[lights[slot].shadowCount].vertices[3] = sp_projection;

    lights[slot].shadowCount += 1;
}

// Draw the light and shadows to the mask for a light
fn drawLightMask(slot: u32) void
{
    // Use the light mask
    c.BeginTextureMode(lights[slot].mask);
    defer c.EndTextureMode();

    c.ClearBackground(c.WHITE);

    // Force the blend mode to only set the alpha of the destination
    c.rlSetBlendFactors(rlgl_src_alpha, rlgl_src_alpha, rlgl_min);
    c.rlSetBlendMode(c.BLEND_CUSTOM);

    // If we are valid, then draw the light radius to the alpha mask
    if (lights[slot].valid)
        c.DrawCircleGradient(@intFromFloat(c_int, lights[slot].position.x),
                             @intFromFloat(c_int, lights[slot].position.y),
                             lights[slot].outer_radius, c.ColorAlpha(c.WHITE, 0), c.WHITE);

    c.rlDrawRenderBatchActive();

    // Cut out the shadows from the light radius by forcing the alpha to maximum
    c.rlSetBlendMode(c.BLEND_ALPHA);
    c.rlSetBlendFactors(rlgl_src_alpha, rlgl_src_alpha, rlgl_max);
    c.rlSetBlendMode(c.BLEND_CUSTOM);

    // Draw the shadows to the alpha mask
    for (0..lights[slot].shadowCount) |i|
        c.DrawTriangleFan(&lights[slot].shadows[i].vertices, 4, c.WHITE);

    c.rlDrawRenderBatchActive();

    // Go back to normal blend mode
    c.rlSetBlendMode(c.BLEND_ALPHA);
}
