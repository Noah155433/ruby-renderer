require './src/object.rb'
require './src/tga_writer.rb'

width = 512
height = 512

color_map = Array.new(width*height*3) {0}
depth_map = Array.new(width*height) {255}

maps = [color_map, depth_map]

suzanne = Obj.new('./src/lantern.obj')
suzanne.set_texture("./src/lantern_texture.png")
suzanne.draw(maps)

Tga_writer.write_tga(maps[0], width, height)