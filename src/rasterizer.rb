require './src/matrix.rb'

class Rasterizer
  def self.draw_tri(tri_data, maps, width, height)

    n = 0.1
    f = 100.0

    proj = Matrix.identity

    fov = 90

    s = 1 / (Math.tan((fov / 2) * (Math::PI / 180)))

    proj.set(0, 0, s)
    proj.set(1, 1, s)

    proj.set(2, 2, -(f/(f-n)))
    proj.set(3, 2, -1)
    proj.set(2, 3, -((f*n)/(f-n)))

    v = tri_data.v

    view = Matrix.identity
    view.set(2, 3, -3)

    proj.dot_matrix!(view)

    v1 = proj.dot_vector(v[0])
    v1 = v1.map { |c| c / v1[3]}
    v2 = proj.dot_vector(v[1])
    v2 = v2.map { |c| c / v2[3]}
    v3 = proj.dot_vector(v[2])
    v3 = v3.map { |c| c / v3[3]}

    [v1, v2, v3].each do |vert|
      vert[0] = ((vert[0] + 1) / 2) * width
      vert[1] = ((vert[1] + 1) / 2) * height
    end

    if (v2[0] < v1[0])
      temp = v1
      v1 = v2
      v2 = temp
    end

    if (v3[0] < v2[0])
      temp = v2
      v2 = v3
      v3 = temp
    end

    if (v2[0] < v1[0])
      temp = v1
      v1 = v2
      v2 = temp
    end

    if (v1[0] - v3[0] != 0)
      if(v1[0] - v2[0] != 0)
        k1 = (v1[1] - v2[1]) / (v1[0] - v2[0])
        m1 = v1[1] - k1 * v1[0]
      end
      if(v2[0] - v3[0] != 0)
        k2 = (v2[1] - v3[1]) / (v2[0] - v3[0])
        m2 = v2[1] - k2 * v2[0]
      end
      k3 = (v1[1] - v3[1]) / (v1[0] - v3[0])
      m3 = v3[1] - k3 * v3[0]

      if(v1[0] - v2[0] != 0)
        for x in v1[0].to_i..v2[0].to_i
          for y in [k1*x+m1, k3*x+m3].min.to_i..[k1*x+m1, k3*x+m3].max.to_i
            colors = [x / (width / 255).to_f, y / (height / 255).to_f, 0]
            for i in 0..2
              maps[0][y * height * 3 + x * 3 + i] = 255
            end
          end
        end
      end
      
      if(v2[0] - v3[0] != 0)
        for x in v2[0].to_i..v3[0].to_i
          for y in [k2*x+m2, k3*x+m3].min.to_i..[k2*x+m2, k3*x+m3].max.to_i
            colors = [x / (width / 255).to_f, y / (height / 255).to_f, 0]
            for i in 0..2
              maps[0][y * height * 3 + x * 3 + i] = 255
            end
          end
        end
      end
    end
  end
end