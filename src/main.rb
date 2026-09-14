require './src/object.rb'
require './src/png_writer.rb'
require './src/vector.rb'

width = 512
height = 512

color_map = Array.new(width*height*3) {0}
depth_map = Array.new(width*height) {255}

maps = [color_map, depth_map]

rasterizer = Rasterizer.new(maps, width, height)
rasterizer.set_ambient_strength(0.3)
rasterizer.set_light_pos(Vec3.new(0, 0.0, -1.0))
rasterizer.set_camera_pos(Vec3.new(0, 0.0, -0.7))

suzanne = Obj.new('./suzanne.obj', rasterizer)
suzanne.set_texture("./uv_grid.png", [1024, 1024])
suzanne.draw

PNG_writer.write_png(maps[0], width, height)