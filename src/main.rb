require './src/object.rb'
require './src/png_writer.rb'
require './src/vector.rb'

width = 512
height = 512

color_map = Array.new(width*height*3) {0}
depth_map = Array.new(width*height) {255}

maps = [color_map, depth_map]

rasterizer = Rasterizer.new(maps, 512, 512)
rasterizer.set_ambient_strength(0.3)
rasterizer.set_light_pos(Vec3.new(0, 0.5, 0))
rasterizer.set_camera_pos(Vec3.new(2, 0.0, -2))

skybox = Obj.new('./skybox.obj', rasterizer)
skybox.set_texture('./skybox_texture.png', [1024, 768])
skybox.draw

suzanne = Obj.new('./fsh.obj', rasterizer)
suzanne.set_texture("./fsh.png", [2048, 2048])
suzanne.draw

PNG_writer.write_png(maps[0], width, height)