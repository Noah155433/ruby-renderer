require './src/tga_writer.rb'

width = 256
height = 256

color_map = Array.new(width*height*3) {255}

Tga_writer.write_tga(color_map, width, height)