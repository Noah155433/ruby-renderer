require 'vips'
class PNG_writer
  def self.write_png(color_map, width, height)

    flat_bytes = color_map.flatten.pack('C*')

    image = Vips::Image.new_from_memory(flat_bytes, width, height, 3, :uchar)
    image.write_to_file('./image.png')

  end
end