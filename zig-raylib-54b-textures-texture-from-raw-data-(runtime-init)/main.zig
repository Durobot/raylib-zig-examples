// build with `zig build-exe main.zig -lc -lraylib`

// This is a Zig version of a raylib example from
// https://github.com/raysan5/raylib/
// It is distributed under the same license as the original - unmodified zlib/libpng license
// Header from the original source code follows below:

///*******************************************************************************************
//*
//*   raylib [textures] example - Load textures from raw data
//*
//*   NOTE: Images are loaded in CPU memory (RAM); textures are loaded in GPU memory (VRAM)
//*
//*   Example originally created with raylib 1.3, last time updated with raylib 3.5
//*
//*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//*   BSD-like license that allows static linking with closed source software
//*
//*   Copyright (c) 2015-2023 Ramon Santamaria (@raysan5)
//*
//********************************************************************************************/

// This version generates the texture at runtime, like the original C example.

// See version 54a for the version that generates the texture at comptime (compilation time).

const std = @import("std"); // std.heap.page_allocator
const c = @cImport(
{
    @cInclude("raylib.h");
});

pub fn main() void
{
    const screen_width = 800;
    const screen_height = 450;

    c.InitWindow(screen_width, screen_height, "raylib [textures] example - texture from raw data");
    defer c.CloseWindow(); // Close window and OpenGL context

    // NOTE: Textures MUST be loaded after Window initialization (OpenGL context is required)

    // Load RAW image data (512x512, 32bit RGBA, no file header).
    // Allocates required memory using malloc().
    const fudesumi_raw = c.LoadImageRaw("resources/fudesumi.raw", 384, 512, c.PIXELFORMAT_UNCOMPRESSED_R8G8B8A8, 0);
    const fudesumi = c.LoadTextureFromImage(fudesumi_raw);  // Upload CPU (RAM) image to GPU (VRAM) - Texture2D
    defer c.UnloadTexture(fudesumi); // Unload texture from GPU memory (VRAM)
    c.UnloadImage(fudesumi_raw); // Free the image.data using free() - see below for explanation if you need one

    // Generate a checked texture by code
    const width = 960;
    const height = 480;

    // Dynamic memory allocation to store pixels data (Color type).
    // Since we want just one large buffer, using OS kernel functions is OK.
    const alloc8r = std.heap.page_allocator;
    //pub const struct_Color = extern struct { r: u8, g: u8,  b: u8, a: u8, };
    //pub const Color = struct_Color;
    var pixels = alloc8r.alloc(c.Color, width * height) catch |err|
    {
        std.debug.print("\nERROR: could not allocate {} bytes for the texture in RAM\n",
                        .{width * height * @sizeOf(c.Color)});
        std.debug.print("{}\n", .{err});
        return;
    };

    // Generate texture data in the allocated memory
    for (0..height) |y|
    {
        for (0..width) |x|
        {
            if (((x / 32 + y / 32) / 1) % 2 == 0)
            {   pixels[y * width + x] = c.ORANGE;   }
            else
                pixels[y * width + x] = c.GOLD;
        }
    }

    // Load pixels data into an image structure and create texture
    const checked_im = c.Image
    {
        // pixels is a pointer already, unlike in 54a
        .data = @ptrCast(?*anyopaque, pixels), // We can assign pixels directly to data
        .width = width,
        .height = height,
        .format = c.PIXELFORMAT_UNCOMPRESSED_R8G8B8A8,
        .mipmaps = 1
    };

    // NOTE: image is not unloaded, it must be done manually
    const checked = c.LoadTextureFromImage(checked_im); // Texture2D
    // The following call
    // --- c.UnloadImage(checked_im);         // Unload CPU (RAM) image data (pixels)
    // does this -
    //void UnloadImage(Image image)
    //{
    //    RL_FREE(image.data);
    //}
    // RL_FREE is defined in raylib.h as
    //#ifndef RL_FREE
    //    #define RL_FREE(ptr)        free(ptr)
    //#endif
    // Translated to Zig as
    //pub inline fn RL_FREE(ptr: anytype) @TypeOf(free(ptr)) {
    //    return free(ptr);
    //}
    // Which means we're not to call UnloadImage(), unless we use malloc() to allocate image pixels,
    // like in the original C code.
    // Instead, we call
    alloc8r.free(pixels);

    //c.SetTargetFPS(60); - Don't need this since we really only display a static image

    while (!c.WindowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        // TODO: Update your variables here
        //----------------------------------------------------------------------------------

        // Draw
        //---------------------------------------------------------------------------------
        {
            c.BeginDrawing();
            defer c.EndDrawing();

            c.ClearBackground(c.RAYWHITE);

            c.DrawTexture(checked,
                          screen_width / 2 - @divTrunc(checked.width, 2),
                          screen_height/2 - @divTrunc(checked.height, 2), c.Fade(c.WHITE, 0.5));
            c.DrawTexture(fudesumi, 430, -30, c.WHITE);

            c.DrawText("CHECKED TEXTURE ", 84, 85, 30, c.BROWN);
            c.DrawText("GENERATED by CODE", 72, 148, 30, c.BROWN);
            c.DrawText("and RAW IMAGE LOADING", 46, 210, 30, c.BROWN);

            c.DrawText("(c) Fudesumi sprite by Eiden Marsal", 310, screen_height - 20, 10, c.BROWN);
        }
        //---------------------------------------------------------------------------------
    }
}
