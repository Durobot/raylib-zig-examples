// build with `zig build-exe main.zig -lc -lraylib`

// This is a Zig version of a raylib example from
// https://github.com/raysan5/raylib/
// It is distributed under the same license as the original - unmodified zlib/libpng license
// Header from the original source code follows below:

///*******************************************************************************************
//*
//*   raylib [core] example - split screen
//*
//*   Example originally created with raylib 3.7, last time updated with raylib 4.0
//*
//*   Example contributed by Jeffery Myers (@JeffM2501) and reviewed by Ramon Santamaria (@raysan5)
//*
//*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//*   BSD-like license that allows static linking with closed source software
//*
//*   Copyright (c) 2021-2023 Jeffery Myers (@JeffM2501)
//*
//********************************************************************************************/

const c = @cImport(
{
    @cInclude("raylib.h");
});

var camera_player1 = c.Camera3D
{
    .position = .{ .x = 0.0, .y = 1.0, .z = -3.0 }, // Camera position
    .target = .{ .x = 0.0, .y = 1.0, .z = 0.0 },    // Camera looking at point
    .up = .{ .x = 0.0, .y = 1.0, .z = 0.0 },        // Camera up vector (rotation towards target)
    .fovy = 45.0,                                   // Camera field-of-view Y
    .projection = c.CAMERA_PERSPECTIVE              // Camera mode type
};

var camera_player2 = c.Camera3D
{
    .position = .{ .x = -3.0, .y = 3.0, .z = 0.0 }, // Camera position
    .target = .{ .x = 0.0, .y = 3.0, .z = 0.0 },    // Camera looking at point
    .up = .{ .x = 0.0, .y = 1.0, .z = 0.0 },        // Camera up vector (rotation towards target)
    .fovy = 45.0,                                   // Camera field-of-view Y
    .projection = c.CAMERA_PERSPECTIVE              // Camera mode type
};

pub fn main() void
{
    const screen_width = 800;
    const screen_height = 450;

    c.InitWindow(screen_width, screen_height, "raylib [core] example - split screen");
    defer c.CloseWindow(); // Close window and OpenGL context

    var screen_player1 = c.LoadRenderTexture(screen_width / 2, screen_height); // RenderTexture
    defer c.UnloadRenderTexture(screen_player1); // Unload render texture
    var screen_player2 = c.LoadRenderTexture(screen_width / 2, screen_height); // RenderTexture
    defer c.UnloadRenderTexture(screen_player2); // Unload render texture

    // Build a flipped rectangle the size of the split view to use for drawing later
    const split_screen_rect = c.Rectangle
    {
        .x = 0.0, .y = 0.0,
        .width = @floatFromInt(screen_player1.texture.width),
        .height = @floatFromInt(-screen_player2.texture.height)
    };

    c.SetTargetFPS(60);

    while (!c.WindowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        // If anyone moves this frame, how far will they move based on the time since the last frame
        // this moves thigns at 10 world units per second, regardless of the actual FPS
        const offset_this_frame = 10.0 * c.GetFrameTime();

        // Move Player1 forward and backwards (no turning)
        if (c.IsKeyDown(c.KEY_W))
        {
            camera_player1.position.z += offset_this_frame;
            camera_player1.target.z += offset_this_frame;
        }
        else if (c.IsKeyDown(c.KEY_S))
        {
            camera_player1.position.z -= offset_this_frame;
            camera_player1.target.z -= offset_this_frame;
        }

        // Move Player2 forward and backwards (no turning)
        if (c.IsKeyDown(c.KEY_UP))
        {
            camera_player2.position.x += offset_this_frame;
            camera_player2.target.x += offset_this_frame;
        }
        else if (c.IsKeyDown(c.KEY_DOWN))
        {
            camera_player2.position.x -= offset_this_frame;
            camera_player2.target.x -= offset_this_frame;
        }
        //----------------------------------------------------------------------------------

        // Draw
        //---------------------------------------------------------------------------------
        // Draw Player1 view to the render texture
        {
            c.BeginTextureMode(screen_player1);
            defer c.EndTextureMode(); // we can use defer to execute this at the end of the block..

            c.ClearBackground(c.SKYBLUE);
            c.BeginMode3D(camera_player1);
                DrawScene();
            c.EndMode3D();
            c.DrawText("PLAYER1 W/S to move", 10, 10, 20, c.RED);
        }

        // Draw Player2 view to the render texture
        c.BeginTextureMode(screen_player2);
            c.ClearBackground(c.SKYBLUE);
            c.BeginMode3D(camera_player2);
                DrawScene();
            c.EndMode3D();
            c.DrawText("PLAYER2 UP/DOWN to move", 10, 10, 20, c.BLUE);
        c.EndTextureMode(); // ..or we can do it the C way

        c.BeginDrawing();
        defer c.EndDrawing();

        c.ClearBackground(c.BLACK);
        c.DrawTextureRec(screen_player1.texture, split_screen_rect,
                         .{ .x = 0.0, .y = 0.0 }, c.WHITE);
        c.DrawTextureRec(screen_player2.texture, split_screen_rect,
                         .{ .x = @as(f32, @floatFromInt(screen_width)) / 2.0, .y = 0 }, c.WHITE);
        c.DrawFPS(10, 30);
        //---------------------------------------------------------------------------------
    }
}

// Scene drawing
fn DrawScene() void
{
    const count = 5;
    const spacing = 4.0;

    // Grid of cube trees on a plane to make a "world"
    c.DrawPlane(.{ .x = 0.0, .y = 0.0, .z = 0.0 }, .{ .x = 50.0, .y = 50.0 }, c.BEIGE); // Simple world plane

    // The trees
    var x: f32 = -count * spacing;
    while (x <= count * spacing) : (x += spacing)
    {
        var z: f32 = -count * spacing;
        while (z <= count * spacing) : (z += spacing)
        {
            c.DrawCube(.{ .x = x, .y = 1.5, .z = z }, 1.0, 1.0, 1.0, c.LIME);
            c.DrawCube(.{ .x = x, .y = 0.5, .z = z }, 0.25, 1.0, 0.25, c.BROWN);
        }
    }

    // Draw a cube at each player's position
    c.DrawCube(camera_player1.position, 1.0, 1.0, 1.0, c.RED);
    c.DrawCube(camera_player2.position, 1.0, 1.0, 1.0, c.BLUE);
}
