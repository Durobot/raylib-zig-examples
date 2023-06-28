// build with `zig build-exe main.zig -lc -lraylib`

// This is a Zig version of a raylib example from
// https://github.com/raysan5/raylib/
// It is distributed under the same license as the original - unmodified zlib/libpng license
// Header from the original source code follows below:

///*******************************************************************************************
//*
//*   raylib example - procedural mesh generation
//*
//*   Example originally created with raylib 1.8, last time updated with raylib 4.0
//*
//*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//*   BSD-like license that allows static linking with closed source software
//*
//*   Copyright (c) 2017-2023 Ramon Santamaria (@raysan5)
//*
//********************************************************************************************/


// This version's GenMeshCustom() uses raylib's MemAlloc() function to allocate RAM.
// MemAlloc(), in turn, uses RL_CALLOC(n,sz) macro, which is defined as calloc(n,sz)

// See version 87b for the version that uses native Zig allocators.

const c = @cImport(
{
    @cInclude("raylib.h");
});

pub fn main() void
{
    const screen_width = 800;
    const screen_height = 450;
    const num_models = 9;

    c.InitWindow(screen_width, screen_height, "raylib [models] example - mesh-generation");
    defer c.CloseWindow(); // Close window and OpenGL context

    const checked = c.GenImageChecked(2, 2, 1, 1, c.RED, c.GREEN); // c.Image
    const texture = c.LoadTextureFromImage(checked); // c.Texture2D
    defer c.UnloadTexture(texture); // Unload texture
    c.UnloadImage(checked);

    var models = [num_models]c.Model // Can't be const, since we update their textures below
    {
        c.LoadModelFromMesh(c.GenMeshPlane(2, 2, 5, 5)),
        c.LoadModelFromMesh(c.GenMeshCube(2.0, 1.0, 2.0)),
        c.LoadModelFromMesh(c.GenMeshSphere(2, 32, 32)),
        c.LoadModelFromMesh(c.GenMeshHemiSphere(2, 16, 16)),
        c.LoadModelFromMesh(c.GenMeshCylinder(1, 2, 16)),
        c.LoadModelFromMesh(c.GenMeshTorus(0.25, 4.0, 16, 32)),
        c.LoadModelFromMesh(c.GenMeshKnot(1.0, 2.0, 16, 128)),
        c.LoadModelFromMesh(c.GenMeshPoly(5, 2.0)),
        c.LoadModelFromMesh(GenMeshCustom())
    };

    // Unload model data (from GPU VRAM)
    defer for (0..num_models) |i| c.UnloadModel(models[i]);

    // Generated meshes could be exported as .obj files
    //c.ExportMesh(models[0].meshes[0], "plane.obj");
    //c.ExportMesh(models[1].meshes[0], "cube.obj");
    //c.ExportMesh(models[2].meshes[0], "sphere.obj");
    //c.ExportMesh(models[3].meshes[0], "hemisphere.obj");
    //c.ExportMesh(models[4].meshes[0], "cylinder.obj");
    //c.ExportMesh(models[5].meshes[0], "torus.obj");
    //c.ExportMesh(models[6].meshes[0], "knot.obj");
    //c.ExportMesh(models[7].meshes[0], "poly.obj");
    //c.ExportMesh(models[8].meshes[0], "custom.obj");

    // Set checked texture as default diffuse component for all models material
    for (0..num_models) |i|
        models[i].materials[0].maps[c.MATERIAL_MAP_DIFFUSE].texture = texture;

    // Define the camera to look into our 3d world
    var camera = c.Camera3D
    {
        .position = .{ .x = 5.0, .y = 5.0, .z = 5.0 }, // Camera position
        .target = .{ .x = 0.0, .y = 0.0, .z = 0.0 },     // Camera looking at point
        .up = .{ .x = 0.0, .y = 1.0, .z = 0.0 },         // Camera up vector (rotation towards target)
        .fovy = 45.0,                                    // Camera field-of-view Y
        .projection = c.CAMERA_PERSPECTIVE               // Camera mode type
    };

    // Model drawing position
    const position = c.Vector3{ .x = 0.0, .y = 0.0, .z = 0.0 };

    var current_model: usize = 0;

    c.SetTargetFPS(60);

    while (!c.WindowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        c.UpdateCamera(&camera, c.CAMERA_ORBITAL);

        if (c.IsMouseButtonPressed(c.MOUSE_BUTTON_LEFT))
            current_model = (current_model + 1) % num_models; // Cycle between the models

        if (c.IsKeyPressed(c.KEY_RIGHT))
        {
            current_model += 1;
            if (current_model >= num_models)
                current_model = 0;
        }
        else
            if (c.IsKeyPressed(c.KEY_LEFT))
            {
                if (current_model <= 1)
                {   current_model = num_models - 1;   }
                else
                    current_model -= 1;
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

            c.DrawModel(models[current_model], position, 1.0, c.WHITE);
            c.DrawGrid(10, 1.0);
        }

        c.DrawRectangle(30, 400, 310, 30, c.Fade(c.SKYBLUE, 0.5));
        c.DrawRectangleLines(30, 400, 310, 30, c.Fade(c.DARKBLUE, 0.5));
        c.DrawText("MOUSE LEFT BUTTON to CYCLE PROCEDURAL MODELS", 40, 410, 10, c.BLUE);

        switch (current_model)
        {
            0 => c.DrawText("PLANE", 680, 10, 20, c.DARKBLUE),
            1 => c.DrawText("CUBE", 680, 10, 20, c.DARKBLUE),
            2 => c.DrawText("SPHERE", 680, 10, 20, c.DARKBLUE),
            3 => c.DrawText("HEMISPHERE", 640, 10, 20, c.DARKBLUE),
            4 => c.DrawText("CYLINDER", 680, 10, 20, c.DARKBLUE),
            5 => c.DrawText("TORUS", 680, 10, 20, c.DARKBLUE),
            6 => c.DrawText("KNOT", 680, 10, 20, c.DARKBLUE),
            7 => c.DrawText("POLY", 680, 10, 20, c.DARKBLUE),
            8 => c.DrawText("Custom (triangle)", 580, 10, 20, c.DARKBLUE),
            else => {}
        }
        //---------------------------------------------------------------------------------
    }
}


// Generate a simple triangle mesh from code
// Warning: uses raylib's MemAlloc() function to allocate RAM.
//          1) we assume allocations are always successful;
//          2) we assume allocated RAM is f32-aligned (4 bytes).
// All the allocated RAM is freed in deferred calls to raylib's UnloadModel() in the main
// function ( https://github.com/raysan5/raylib/blob/7d68aa686974347cefe0ef481c835e3d60bdc4b9/src/rmodels.c#L1123 )
// UnloadModel() calls UnloadMesh() in a loop for all the meshes of the model, then uses raylib's RL_FREE macro
// to free the materials in a similar fashion. Then it uses RL_FREE to free the array of mesh pointers, the array
// of material pointers, etc.
fn GenMeshCustom() c.Mesh
{
    var mesh = c.Mesh
    {
        .vertexCount = 3,
        .triangleCount = 1,
        // @ptrCast -> [*c]f32, @alignCast -> @alignOf(f32)
        .vertices = @ptrCast(@alignCast(c.MemAlloc(3 * 3 * @sizeOf(f32)).?)), // 3 vertices, 3 coordinates each (x, y, z)
        // @ptrCast -> [*c]f32, @alignCast -> @alignOf(f32)
        .texcoords = @ptrCast(@alignCast(c.MemAlloc(3 * 2 * @sizeOf(f32)).?)), // 3 vertices, 2 coordinates each (x, y)
        .texcoords2 = null,
        // @ptrCast -> [*c]f32, @alignCast -> @alignOf(f32)
        .normals = @ptrCast(@alignCast(c.MemAlloc(3 * 3 * @sizeOf(f32)).?)), // 3 vertices, 3 coordinates each (x, y, z)
        .tangents = null, .colors = null, .indices = null, .animVertices = null, .animNormals = null,
        .boneIds = null, .boneWeights = null, .vaoId = 0,
        // UploadMesh() uses RL_CALLOC() macro to allocate MAX_MESH_VERTEX_BUFFERS unsigned ints,
        // and saves the pointer to them in .vboId
        .vboId = null
    };
    // Vertex at (0, 0, 0)
    mesh.vertices[0] = 0.0;
    mesh.vertices[1] = 0.0;
    mesh.vertices[2] = 0.0;
    mesh.normals[0] = 0.0;
    mesh.normals[1] = 1.0;
    mesh.normals[2] = 0.0;
    mesh.texcoords[0] = 0.0;
    mesh.texcoords[1] = 0.0;

    // Vertex at (1, 0, 2)
    mesh.vertices[3] = 1.0;
    mesh.vertices[4] = 0.0;
    mesh.vertices[5] = 2.0;
    mesh.normals[3] = 0.0;
    mesh.normals[4] = 1.0;
    mesh.normals[5] = 0.0;
    mesh.texcoords[2] = 0.5;
    mesh.texcoords[3] = 1.0;

    // Vertex at (2, 0, 0)
    mesh.vertices[6] = 2.0;
    mesh.vertices[7] = 0.0;
    mesh.vertices[8] = 0.0;
    mesh.normals[6] = 0.0;
    mesh.normals[7] = 1.0;
    mesh.normals[8] = 0.0;
    mesh.texcoords[4] = 1.0;
    mesh.texcoords[5] = 0.0;

    // Upload mesh data from CPU (RAM) to GPU (VRAM) memory
    c.UploadMesh(&mesh, false);

    return mesh;
}
