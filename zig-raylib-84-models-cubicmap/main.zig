// build with `zig build-exe main.zig -lc -lraylib`

// This is a Zig version of a raylib example from
// https://github.com/raysan5/raylib/
// It is distributed under the same license as the original - unmodified zlib/libpng license
// Header from the original source code follows below:

///*******************************************************************************************
//*
//*   raylib [models] example - Cubicmap loading and drawing
//*
//*   Example originally created with raylib 1.8, last time updated with raylib 3.5
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

    c.InitWindow(screen_width, screen_height, "raylib [models] example - cubesmap loading and drawing");
    defer c.CloseWindow(); // Close window and OpenGL context

    // Define the camera to look into our 3d world
    var camera = c.Camera3D
    {
        .position = .{ .x = 16.0, .y = 14.0, .z = 16.0 }, // Camera position
        .target = .{ .x = 0.0, .y = 0.0, .z = 0.0 },      // Camera looking at point
        .up = .{ .x = 0.0, .y = 1.0, .z = 0.0 },          // Camera up vector (rotation towards target)
        .fovy = 45.0,                                     // Camera field-of-view Y
        .projection = c.CAMERA_PERSPECTIVE                // Camera mode type
    };

    const image = c.LoadImage("resources/cubicmap.png"); // Load cubicmap image (RAM) - c.Image
    const cubicmap = c.LoadTextureFromImage(image); // Convert image to texture to display (VRAM) - c.Texture2D

    const mesh = c.GenMeshCubicmap(image, .{ .x = 1.0, .y = 1.0, .z = 1.0 }); // c.Mesh
    const model = c.LoadModelFromMesh(mesh); // c.Model
    defer c.UnloadModel(model); // Unload map model

    // NOTE: By default each cube is mapped to one part of texture atlas
    const texture = c.LoadTexture("resources/cubicmap_atlas.png"); // Load map texture - c.Texture2D
    defer c.UnloadTexture(texture); // Unload map texture
    defer c.UnloadTexture(cubicmap); // Unload cubicmap texture
    model.materials[0].maps[c.MATERIAL_MAP_DIFFUSE].texture = texture; // Set map diffuse texture

    const map_pos = c.Vector3{ .x = -16.0, .y = 0.0, .z = -8.0 }; // Set model position

    c.UnloadImage(image); // Unload cubesmap image from RAM, already uploaded to VRAM

    c.SetTargetFPS(60);

    while (!c.WindowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        c.UpdateCamera(&camera, c.CAMERA_ORBITAL);
        //----------------------------------------------------------------------------------

        // Draw
        //---------------------------------------------------------------------------------
        c.BeginDrawing();
        defer c.EndDrawing();

        c.ClearBackground(c.RAYWHITE);
        {
            c.BeginMode3D(camera);
            defer c.EndMode3D();

            c.DrawModel(model, map_pos, 1.0, c.WHITE);
        }
        c.DrawTextureEx(cubicmap, .{ .x = screen_width - @as(f32, @floatFromInt(cubicmap.width)) * 4.0 - 20.0, .y = 20.0 },
                        0.0, 4.0, c.WHITE);
        c.DrawRectangleLines(screen_width - cubicmap.width * 4 - 20, 20, cubicmap.width * 4, cubicmap.height * 4, c.GREEN);

        c.DrawText("cubicmap image used to", 658, 90, 10, c.GRAY);
        c.DrawText("generate map 3d model", 658, 104, 10, c.GRAY);

        c.DrawFPS(10, 10);
        //---------------------------------------------------------------------------------
    }
}
