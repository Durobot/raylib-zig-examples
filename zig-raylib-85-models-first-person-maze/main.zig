// build with `zig build-exe main.zig -lc -lraylib`

// This is a Zig version of a raylib example from
// https://github.com/raysan5/raylib/
// It is distributed under the same license as the original - unmodified zlib/libpng license
// Header from the original source code follows below:

///*******************************************************************************************
//*
//*   raylib [models] example - first person maze
//*
//*   Example originally created with raylib 2.5, last time updated with raylib 3.5
//*
//*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//*   BSD-like license that allows static linking with closed source software
//*
//*   Copyright (c) 2019-2023 Ramon Santamaria (@raysan5)
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

    c.InitWindow(screen_width, screen_height, "raylib [models] example - first person maze");
    defer c.CloseWindow(); // Close window and OpenGL context

    // Define the camera to look into our 3d world
    var camera = c.Camera3D
    {
        .position = .{ .x = 0.2, .y = 0.4, .z = 0.2 }, // Camera position
        .target = .{ .x = 0.185, .y = 0.4, .z = 0.0 }, // Camera looking at point
        .up = .{ .x = 0.0, .y = 1.0, .z = 0.0 },       // Camera up vector (rotation towards target)
        .fovy = 45.0,                                  // Camera field-of-view Y
        .projection = c.CAMERA_PERSPECTIVE             // Camera mode type
    };

    const im_map = c.LoadImage("resources/cubicmap.png"); // Load cubicmap image (RAM) - c.Image
    const cubicmap = c.LoadTextureFromImage(im_map); // Convert image to texture to display (VRAM) - c.Texture2D

    const mesh = c.GenMeshCubicmap(im_map, .{ .x = 1.0, .y = 1.0, .z = 1.0 }); // c.Mesh
    const model = c.LoadModelFromMesh(mesh); // c.Model
    defer c.UnloadModel(model); // Unload map model

    // NOTE: By default each cube is mapped to one part of texture atlas
    const texture = c.LoadTexture("resources/cubicmap_atlas.png"); // Load map texture - c.Texture2D
    defer c.UnloadTexture(texture); // Unload map texture
    defer c.UnloadTexture(cubicmap); // Unload cubicmap texture
    model.materials[0].maps[c.MATERIAL_MAP_DIFFUSE].texture = texture; // Set map diffuse texture

    const map_pos = c.Vector3{ .x = -16.0, .y = 0.0, .z = -8.0 }; // Set model position

    // Get map image data to be used for collision detection
    const map_pixels = c.LoadImageColors(im_map); // [*c]Color
    defer c.UnloadImageColors(map_pixels); // Unload color array
    c.UnloadImage(im_map); // Unload cubesmap image from RAM, already uploaded to VRAM

    c.DisableCursor(); // Limit cursor to relative movement inside the window

    c.SetTargetFPS(60);

    while (!c.WindowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        const old_cam_pos = camera.position; // Store old camera position

        c.UpdateCamera(&camera, c.CAMERA_FIRST_PERSON);

        // Check player collision (we simplify to 2D collision detection)
        const player_pos = .{ .x = camera.position.x, .y = camera.position.z };
        const player_radius = 0.1; // Collision radius (player is modelled as a cilinder for collision)

        var player_cell_x = @floatToInt(i32, player_pos.x - map_pos.x + 0.5);
        var player_cell_y = @floatToInt(i32, player_pos.y - map_pos.z + 0.5);

        // Out-of-limits security check
        if (player_cell_x < 0)
        {   player_cell_x = 0;   }
        else
            if (player_cell_x >= cubicmap.width)
                player_cell_x = cubicmap.width - 1;

        if (player_cell_y < 0)
        {   player_cell_y = 0;   }
        else
            if (player_cell_y >= cubicmap.height)
                player_cell_y = cubicmap.height - 1;

        // Check map collisions using image data and player position
        // TODO: Improvement: Just check player surrounding cells for collision
        for (0..@intCast(usize, cubicmap.height)) |y|
        {
            for (0..@intCast(usize, cubicmap.width)) |x|
            {
                if ((map_pixels[y * @intCast(usize, cubicmap.width) + x].r == 255) and // Collision: white pixel, only check R channel
                    c.CheckCollisionCircleRec(player_pos, player_radius,
                                              .{ .x = map_pos.x - 0.5 + @intToFloat(f32, x),
                                                 .y = map_pos.z - 0.5 + @intToFloat(f32, y),
                                                 .width = 1.0, .height = 1.0 }))
                    camera.position = old_cam_pos; // Collision detected, reset camera position
            }
        }
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

        c.DrawTextureEx(cubicmap,
                        .{ .x = @intToFloat(f32, c.GetScreenWidth() - cubicmap.width * 4 - 20),
                           .y = 20.0 }, 0.0, 4.0, c.WHITE);
        c.DrawRectangleLines(c.GetScreenWidth() - cubicmap.width * 4 - 20, 20,
                             cubicmap.width * 4, cubicmap.height * 4, c.GREEN);

        // Draw player position radar
        c.DrawRectangle(c.GetScreenWidth() - cubicmap.width * 4 - 20 + player_cell_x * 4,
                        20 + player_cell_y * 4, 4, 4, c.RED);

        c.DrawFPS(10, 10);
        //---------------------------------------------------------------------------------
    }
}
