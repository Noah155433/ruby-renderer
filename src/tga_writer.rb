class Tga_writer
  def self.write_tga(color_map, width, height)

    header = Array.new(18) {0}

    header[2] = 2
    header[12] = width & 0x00FF
    header[13] = (width >> 8) & 0x00FF
    header[14] = height & 0x00FF
    header[15] = (height >> 8) & 0x00FF
    header[16] = 24

    header = header.pack('C'*18)

    color_map = color_map.pack('C'*(width*height*3))

    f = File.open('render.tga', 'wb')

    f.write(header, color_map)

    f.close
  end
end