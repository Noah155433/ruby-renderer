require './src/triangle_data.rb'
require './src/rasterizer.rb'
require './src/img.rb'

class Obj
  def initialize(filepath)
    
    @texture = [0, 0]

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
        @v[v_count] = line
        v_count += 1
      elsif line[0] == "vn"
        line.shift
        for i in 0..2
          line [i] = line[i].to_f
        end
        @vn[vn_count] = line
        vn_count += 1
      elsif line[0] == "vt"
        line.shift
        for i in 0..1
          line[i] = line[i].to_f
        end
        @vt[vt_count] = line
        vt_count += 1
      elsif line[0] == "f"
        line.shift
        @f[f_count] = line
        f_count += 1
      end
    end
  end

  def set_texture(filepath)
    @texture = Img.get_rgb_array(filepath)
  end

  def draw(maps)
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
      
      Rasterizer.draw_tri(tri_data1, maps, 512, 512, @texture, [1024, 1024])
      
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

        Rasterizer.draw_tri(tri_data2, maps, 512, 512, @texture, [1024, 1024])
      end
    end
  end
end