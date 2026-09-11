require 'vips'

class Img
  def self.get_rgb_array(filename)
    image = Vips::Image.new_from_file(filename)

    image = image.colourspace(:srgb)
    image = image.extract_band(0, n: 3)
    image = image.cast(:uchar)

    return image.write_to_memory.bytes
  end
end