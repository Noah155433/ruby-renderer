require './src/object.rb'
require './src/png_writer.rb'
require './src/vector.rb'
require './src/img.rb'

width = 1440
height = 1440

color_map = Array.new(width*height*3) {0}
color_map, x = Img.get_rgb_array('skybox_texture(2).jpg')
depth_map = Array.new(width*height) {Float::INFINITY}

maps = [color_map, depth_map]

rasterizer = Rasterizer.new(maps, width, height)
rasterizer.set_world_ambient_strength(1.0)
rasterizer.set_ambient_strength(0.1)
rasterizer.set_specular_strength(0.4)
rasterizer.set_light_pos(Vec3.new(0.3, 0.4, -0.6))
rasterizer.set_camera_pos(Vec3.new(0, 0.4, 1.5))

#skybox = Obj.new('./skybox.obj', rasterizer)
#skybox.set_texture("./skybox_texture.png")
#skybox.draw

suzanne = Obj.new('./suzanne.obj', rasterizer)
suzanne.set_texture('./uv_grid.png')
suzanne.set_scale(Vec3.new(0.5, 0.5, 0.5))
suzanne.set_position(Vec3.new(0.0, 0.5, -0.6))
suzanne.set_rotation(Vec3.new(-20, -30, 0))
suzanne.draw

#plane = Obj.new('./plane.obj', rasterizer)
#plane.set_texture('./uv_grid.png')
#plane.set_scale(Vec3.new(2.0, 1.0, 1.0))
#plane.draw

PNG_writer.write_png(maps[0], width, height)