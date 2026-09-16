require './src/object.rb'
require './src/png_writer.rb'
require './src/vector.rb'
require './src/img.rb'
require './src/light.rb'

width = 512
height = 512

color_map = Array.new(width*height*3) {0}
color_map, x = Img.get_rgb_array('skybox_texture.png')
depth_map = Array.new(width*height) {Float::INFINITY}

maps = [color_map, depth_map]

rasterizer = Rasterizer.new(maps, width, height)
rasterizer.set_world_ambient_strength(0.3)
rasterizer.set_camera_pos(Vec3.new(0, 0.4, 1.5))

light1 = Light.new
light1.pos = Vec3.new(1.0, 0.4, 0)
light1.ambient_strength = 0.7
light1.diffuse_strength = 1.0
light1.specular_strength = 0.7
light1.color = Vec3.new(0, 0, 1.0)

light2 = Light.new
light2.pos = Vec3.new(-1.0, 0.4, 0)
light2.ambient_strength = 0.3
light2.diffuse_strength = 1.0
light2.specular_strength = 0.3
light2.color = Vec3.new(1.0, 0, 0)

light3 = Light.new
light3.pos = Vec3.new(1.0, 0.4, -0.5)
light3.ambient_strength = 0.1
light3.diffuse_strength = 0.2
light3.specular_strength = 0.1
light3.color = Vec3.new(0, 1.0, 0)

rasterizer.add_light(light1)
rasterizer.add_light(light2)

#skybox = Obj.new('./skybox.obj', rasterizer)
#skybox.set_texture("./skybox_texture.png")
#skybox.draw

suzanne = Obj.new('./Chair.obj', rasterizer)
suzanne.set_texture('./white.png')
suzanne.set_rotation(Vec3.new(0, 30, 0))
suzanne.draw

#plane = Obj.new('./plane.obj', rasterizer)
#plane.set_texture('./uv_grid.png')
#plane.set_scale(Vec3.new(2.0, 1.0, 1.0))
#plane.draw

PNG_writer.write_png(maps[0], width, height)