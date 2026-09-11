require './src/tga_writer.rb'
require './src/rasterizer.rb'
require './src/triangle_data.rb'

width = 512
height = 512

color_map = Array.new(width*height*3) {0}
depth_map = Array.new(width*height) {0}

maps = [color_map, depth_map]

tri_data = Tri_data.new(
    [(0.25 * width).to_i, (0.25 * width).to_i, 0], 
    [(0.25 * width).to_i, (0.75 * width).to_i, 0], 
    [(0.75 * width).to_i, (0.25 * width).to_i, 0]
    )

tri2_data = Tri_data.new(
    [(0.25 * width).to_i, (0.75 * width).to_i, 0], 
    [(0.75 * width).to_i, (0.75 * width).to_i, 0], 
    [(0.75 * width).to_i, (0.25 * width).to_i, 0]
    )

Rasterizer.draw_tri(tri_data, maps, width, height)
Rasterizer.draw_tri(tri2_data, maps, width, height)

Tga_writer.write_tga(color_map, width, height)