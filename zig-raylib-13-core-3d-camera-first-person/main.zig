// build with `zig build-exe main.zig -lc -lraylib`

// This is a Zig version of a raylib example from
// https://github.com/raysan5/raylib/
// It is distributed under the same license as the original - unmodified zlib/libpng license
// Header from the original source code follows below:

///*******************************************************************************************
//*
//*   raylib [core] example - 3d camera first person
//*
//*   Example originally created with raylib 1.3, last time updated with raylib 1.3
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
    @cInclude("rcamera.h");
});

const std = @import("std");

pub fn main() void
{
    const screenWidth = 800;
    const screenHeight = 450;
    const max_columns = 20;

    c.InitWindow(screenWidth, screenHeight, "raylib [core] example - 3d camera first person");
    defer c.CloseWindow(); // Close window and OpenGL context

    // Define the camera to look into our 3d world
    var camera = c.Camera3D
    {
        .position = .{ .x = 0.0, .y = 2.0, .z = 4.0 }, // Camera position
        .target = .{ .x = 0.0, .y = 2.0, .z = 0.0 },     // Camera looking at point
        .up = .{ .x = 0.0, .y = 1.0, .z = 0.0 },         // Camera up vector (rotation towards target)
        .fovy = 60.0,                                    // Camera field-of-view Y
        .projection = c.CAMERA_PERSPECTIVE               // Camera mode type
    };
    var camera_mode = c.CAMERA_FIRST_PERSON;

    // Generates some random columns
    var heights = [_]f32{ 0.0 } ** max_columns;
    var positions = [_]c.Vector3{ .{.x = 0.0, .y = 0.0, .z = 0.0} } ** max_columns;
    var colors = [_]c.Color{ .{.r = 0, .g = 0, .b = 0, .a = 0} } ** max_columns;

    //var i: usize = 0;
    //while (i < max_columns) : (i += 1)
    for (0..max_columns) |i|
    {
        heights[i] = @floatFromInt(c.GetRandomValue(1, 12));
        positions[i] = .{ .x = @floatFromInt(c.GetRandomValue(-15, 15)), .y = heights[i]/2.0, .z = @floatFromInt(c.GetRandomValue(-15, 15)) };
        colors[i] = .{ .r = @intCast(c.GetRandomValue(20, 255)), .g = @intCast(c.GetRandomValue(10, 55)), .b = 30, .a = 255 }; // u8
    }

    c.DisableCursor(); // Limit cursor to relative movement inside the window
    c.SetTargetFPS(60); // Set our game to run at 60 frames-per-second

    while (!c.WindowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        // Switch camera mode
        if (c.IsKeyPressed(c.KEY_ONE))
        {
            camera_mode = c.CAMERA_FREE;
            camera.up = .{ .x = 0.0, .y = 1.0, .z = 0.0 }; // Reset roll
        }

        if (c.IsKeyPressed(c.KEY_TWO))
        {
            camera_mode = c.CAMERA_FIRST_PERSON;
            camera.up = .{ .x = 0.0, .y = 1.0, .z = 0.0 }; // Reset roll
        }

        if (c.IsKeyPressed(c.KEY_THREE))
        {
            camera_mode = c.CAMERA_THIRD_PERSON;
            camera.up = .{ .x = 0.0, .y = 1.0, .z = 0.0 }; // Reset roll
        }

        if (c.IsKeyPressed(c.KEY_FOUR))
        {
            camera_mode = c.CAMERA_ORBITAL;
            camera.up = .{ .x = 0.0, .y = 1.0, .z = 0.0 }; // Reset roll
        }

        // Switch camera projection
        if (c.IsKeyPressed(c.KEY_P))
        {
            if (camera.projection == c.CAMERA_PERSPECTIVE)
            {
                // Create isometric view
                camera_mode = c.CAMERA_THIRD_PERSON;
                // Note: The target distance is related to the render distance in the orthographic projection
                camera.position = .{ .x = 0.0, .y = 2.0, .z = -100.0 };
                camera.target = .{ .x = 0.0, .y = 2.0, .z = 0.0 };
                camera.up = .{ .x = 0.0, .y = 1.0, .z = 0.0 };
                camera.projection = c.CAMERA_ORTHOGRAPHIC;
                camera.fovy = 20.0; // near plane width in CAMERA_ORTHOGRAPHIC
                c.CameraYaw(&camera, -135.0 * c.DEG2RAD, true);
                c.CameraPitch(&camera, -45.0 * c.DEG2RAD, true, true, false);
            }
            else if (camera.projection == c.CAMERA_ORTHOGRAPHIC)
            {
                // Reset to default view
                camera_mode = c.CAMERA_THIRD_PERSON;
                camera.position = .{ .x = 0.0, .y = 2.0, .z = 10.0 };
                camera.target = .{ .x = 0.0, .y = 2.0, .z = 0.0 };
                camera.up = .{ .x = 0.0, .y = 1.0, .z = 0.0 };
                camera.projection = c.CAMERA_PERSPECTIVE;
                camera.fovy = 60.0;
            }
        }

        // Update camera computes movement internally depending on the camera mode
        // Some default standard keyboard/mouse inputs are hardcoded to simplify use
        // For advance camera controls, it's reecommended to compute camera movement manually
        c.UpdateCamera(&camera, camera_mode);                  // Update camera

        // -- I have not ported this section to Zig, the code commented out below is in original C --
        // Camera PRO usage example (EXPERIMENTAL)
        // This new camera function allows custom movement/rotation values to be directly provided
        // as input parameters, with this approach, rcamera module is internally independent of raylib inputs
        //UpdateCameraPro(&camera,
        //    (Vector3){
        //        (IsKeyDown(KEY_W) || IsKeyDown(KEY_UP))*0.1f -      // Move forward-backward
        //        (IsKeyDown(KEY_S) || IsKeyDown(KEY_DOWN))*0.1f,
        //        (IsKeyDown(KEY_D) || IsKeyDown(KEY_RIGHT))*0.1f -   // Move right-left
        //        (IsKeyDown(KEY_A) || IsKeyDown(KEY_LEFT))*0.1f,
        //        0.0f                                                // Move up-down
        //    },
        //    (Vector3){
        //        GetMouseDelta().x*0.05f,                            // Rotation: yaw
        //        GetMouseDelta().y*0.05f,                            // Rotation: pitch
        //        0.0f                                                // Rotation: roll
        //    },
        //    GetMouseWheelMove()*2.0f);                              // Move to target (zoom)
        //----------------------------------------------------------------------------------

        // Draw
        //---------------------------------------------------------------------------------
        c.BeginDrawing();
        defer c.EndDrawing();

        c.ClearBackground(c.RAYWHITE);
        {
            c.BeginMode3D(camera);
            defer c.EndMode3D();

            c.DrawPlane(.{ .x = 0.0, .y = 0.0, .z =  0.0 }, .{ .x = 32.0, .y = 32.0 }, c.LIGHTGRAY); // Draw ground
            c.DrawCube(.{ .x = -16.0, .y = 2.5, .z =  0.0 }, 1.0, 5.0, 32.0, c.BLUE); // Draw a blue wall
            c.DrawCube(.{ .x =  16.0, .y = 2.5, .z =  0.0 }, 1.0, 5.0, 32.0, c.LIME); // Draw a green wall
            c.DrawCube(.{ .x =   0.0, .y = 2.5, .z = 16.0 }, 32.0, 5.0, 1.0, c.GOLD); // Draw a yellow wall

            // Draw some cubes around
            for (0..max_columns) |i|
            {
                c.DrawCube(positions[i], 2.0, heights[i], 2.0, colors[i]);
                c.DrawCubeWires(positions[i], 2.0, heights[i], 2.0, c.MAROON);
            }

            // Draw player cube
            if (camera_mode == c.CAMERA_THIRD_PERSON)
            {
                c.DrawCube(camera.target, 0.5, 0.5, 0.5, c.PURPLE);
                c.DrawCubeWires(camera.target, 0.5, 0.5, 0.5, c.DARKPURPLE);
            }
        }

        // Draw info boxes
        c.DrawRectangle(5, 5, 330, 100, c.Fade(c.SKYBLUE, 0.5));
        c.DrawRectangleLines(5, 5, 330, 100, c.BLUE);

        c.DrawText("Camera controls:", 15, 15, 10, c.BLACK);
        c.DrawText("- Move keys: W, A, S, D, Space, Left-Ctrl", 15, 30, 10, c.BLACK);
        c.DrawText("- Look around: arrow keys or mouse", 15, 45, 10, c.BLACK);
        c.DrawText("- Camera mode keys: 1, 2, 3, 4", 15, 60, 10, c.BLACK);
        c.DrawText("- Zoom keys: num-plus, num-minus or mouse scroll", 15, 75, 10, c.BLACK);
        c.DrawText("- Camera projection key: P", 15, 90, 10, c.BLACK);

        c.DrawRectangle(600, 5, 195, 100, c.Fade(c.SKYBLUE, 0.5));
        c.DrawRectangleLines(600, 5, 195, 100, c.BLUE);

        c.DrawText("Camera status:", 610, 15, 10, c.BLACK);
        // @ptrCast -> [*c]const u8: https://github.com/ziglang/zig/issues/16234
        // -- This code causes Zig compiler (0.11.0-dev.3859+88284c124) to segfault, see
        // -- https://github.com/ziglang/zig/issues/16197
        //c.DrawText(c.TextFormat("- Mode: %s", @ptrCast(if (camera_mode == c.CAMERA_FREE) "FREE" else
        //                                               if (camera_mode == c.CAMERA_FIRST_PERSON) "FIRST_PERSON" else
        //                                               if (camera_mode == c.CAMERA_THIRD_PERSON) "THIRD_PERSON" else
        //                                               if (camera_mode == c.CAMERA_ORBITAL) "ORBITAL" else "CUSTOM")),
        //           610, 30, 10, c.BLACK);
        const text_cam_mode = if (camera_mode == c.CAMERA_FREE) "- Mode: FREE" else
                              if (camera_mode == c.CAMERA_FIRST_PERSON) "- Mode: FIRST_PERSON" else
                              if (camera_mode == c.CAMERA_THIRD_PERSON) "- Mode: THIRD_PERSON" else
                              if (camera_mode == c.CAMERA_ORBITAL) "- Mode: ORBITAL" else "- Mode: CUSTOM";
        c.DrawText(text_cam_mode, 610, 30, 10, c.BLACK);
        // @ptrCast -> [*c]const u8: https://github.com/ziglang/zig/issues/16234
        // -- This code causes Zig compiler (0.11.0-dev.3859+88284c124) to segfault, see
        // -- https://github.com/ziglang/zig/issues/16197
        //c.DrawText(c.TextFormat("- Projection: %s", if (camera.projection == c.CAMERA_PERSPECTIVE) "PERSPECTIVE" else
        //                                            if (camera.projection == c.CAMERA_ORTHOGRAPHIC) "ORTHOGRAPHIC" else "CUSTOM"),
        //           610, 45, 10, c.BLACK);
        const text_proj = if (camera.projection == c.CAMERA_PERSPECTIVE) "- Projection: PERSPECTIVE" else
                          if (camera.projection == c.CAMERA_ORTHOGRAPHIC) "- Projection: ORTHOGRAPHIC" else
                          "- Projection: CUSTOM";
        c.DrawText(text_proj, 610, 45, 10, c.BLACK);
        c.DrawText(c.TextFormat("- Position: (%06.3f, %06.3f, %06.3f)", camera.position.x, camera.position.y, camera.position.z),
                   610, 60, 10, c.BLACK);
        c.DrawText(c.TextFormat("- Target: (%06.3f, %06.3f, %06.3f)", camera.target.x, camera.target.y, camera.target.z),
                   610, 75, 10, c.BLACK);
        c.DrawText(c.TextFormat("- Up: (%06.3f, %06.3f, %06.3f)", camera.up.x, camera.up.y, camera.up.z), 610, 90, 10, c.BLACK);

        //---------------------------------------------------------------------------------
    }
}
