require './src/triangle_data.rb'
require './src/rasterizer.rb'
require './src/img.rb'
require './src/vector.rb'
require './src/matrix.rb'

class Obj
  def initialize(filepath, rasterizer)

    @rasterizer = rasterizer

    @pos = Vec3.new(0, 0, 0)
    @rotation = Vec3.new(0, 0, 0)
    @scale = Vec3.new(1, 1, 1)

    v_count = 0
    vn_count = 0
    vt_count = 0
    f_count = 0
    
    @v = Array.new
    @vn = Array.new
    @vt = Array.new
    @f = Array.new

    File.readlines(filepath, chomp: true).each do |line|
      line = line.split(" ")
      if line[0] == "v"
        line.shift
        for i in 0..2
          line[i] = line[i].to_f
        end
        @v[v_count] = Vec3.new(line[0], line[1], line[2])
        v_count += 1
      elsif line[0] == "vn"
        line.shift
        for i in 0..2
          line [i] = line[i].to_f
        end
        @vn[vn_count] = Vec3.new(line[0], line[1], line[2])
        vn_count += 1
      elsif line[0] == "vt"
        line.shift
        for i in 0..1
          line[i] = line[i].to_f
        end
        @vt[vt_count] = Vec3.new(line[0], line[1])
        vt_count += 1
      elsif line[0] == "f"
        line.shift
        @f[f_count] = line
        f_count += 1
      end
    end
  end

  def set_position(pos)
    @pos = pos
  end

  def set_rotation(rot)
    @rotation = rot
  end

  def set_scale(scale)
    @scale = scale
  end

  def set_texture(filepath)
    @texture, @tex_size = Img.get_rgb_array(filepath)
  end

  def draw()

    translation_matrix = Matrix.identity
    translation_matrix[3][0] = @pos.x
    translation_matrix[3][1] = @pos.y
    translation_matrix[3][2] = @pos.z

    scale_matrix = Matrix.identity
    scale_matrix[0][0] = @scale.x
    scale_matrix[1][1] = @scale.y
    scale_matrix[2][2] = @scale.z

    rad_x = @rotation.x * Math::PI / 180.0
    rad_y = @rotation.y * Math::PI / 180.0
    rad_z = @rotation.z * Math::PI / 180.0

    cx = Math.cos(rad_x)
    sx = Math.sin(rad_x)
    cy = Math.cos(rad_y)
    sy = Math.sin(rad_y)
    cz = Math.cos(rad_z)
    sz = Math.sin(rad_z)

    rotation_matrix = Matrix.identity

    rotation_matrix[0][0] = cy * cz
    rotation_matrix[0][1] = cy * sz
    rotation_matrix[0][2] = -sy

    rotation_matrix[1][0] = sx * sy * cz - cx * sz
    rotation_matrix[1][1] = sx * sy * sz + cx * cz
    rotation_matrix[1][2] = sx * cy

    rotation_matrix[2][0] = cx * sy * cz + sx * sz
    rotation_matrix[2][1] = cx * sy * sz - sx * cz
    rotation_matrix[2][2] = cx * cy

    transformation_matrix = translation_matrix * rotation_matrix * scale_matrix

    @rasterizer.set_object_matrix(transformation_matrix)

    @rasterizer.set_texture(@texture, @tex_size)

    for i in @f
      v_index = Array.new(4)
      vn_index = Array.new(4)
      vt_index = Array.new(4)
      for j in 0..2
        parts = i[j].split("/")
        v_index[j] = parts[0].to_i - 1
        vn_index[j] = parts[2].to_i - 1
        vt_index[j] = parts[1].to_i - 1 
      end

      tri_data1 = Tri_data.new(
        [
          @v[v_index[2]], 
          @v[v_index[1]], 
          @v[v_index[0]],
        ],
        [
          @vn[vn_index[2]],
          @vn[vn_index[1]],
          @vn[vn_index[0]]
        ],
        [
          @vt[vt_index[2]],
          @vt[vt_index[1]],
          @vt[vt_index[0]]
        ]
        )
      
      @rasterizer.draw_tri(tri_data1)
      
      if i.length == 4

        v_index = []
        vn_index = []
        vt_index = []

        indice_order = [0, 2, 3]
        for j in 0..2
          parts = i[indice_order[j]].split("/")
          v_index[j] = parts[0].to_i - 1
          vn_index[j] = parts[2].to_i - 1
          vt_index[j] = parts[1].to_i - 1 
        end

        tri_data2 = Tri_data.new(
        [
          @v[v_index[2]], 
          @v[v_index[1]], 
          @v[v_index[0]],
        ],
        [
          @vn[vn_index[2]],
          @vn[vn_index[1]],
          @vn[vn_index[0]]
        ],
        [
          @vt[vt_index[2]],
          @vt[vt_index[1]],
          @vt[vt_index[0]]
        ]
        )

        @rasterizer.draw_tri(tri_data2)
      end
    end
  end
end