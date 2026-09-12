require './src/object.rb'
require './src/tga_writer.rb'
require './src/vector.rb'

width = 512
height = 512

color_map = Array.new(width*height*3) {0}
depth_map = Array.new(width*height) {255}

maps = [color_map, depth_map]

rasterizer = Rasterizer.new(maps, 512, 512)
rasterizer.set_ambient_strength(0.3)
rasterizer.set_light_pos(Vec3.new(0, 0.4, 0.5))
rasterizer.set_camera_pos(Vec3.new(0, 0.4, 0.3))

skybox = Obj.new('./skybox.obj', rasterizer)
skybox.set_texture('./skybox_texture.png', [1024, 768])
skybox.draw

suzanne = Obj.new('./plane.obj', rasterizer)
suzanne.set_texture("./uv_grid.png", [1024, 1024])
suzanne.draw

Tga_writer.write_tga(maps[0], width, height)