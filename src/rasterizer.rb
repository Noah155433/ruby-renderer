class Rasterizer
  def self.draw_tri(tri_data, maps, width, height)

    v = tri_data.v

    v1 = v[0]
    v2 = v[1]
    v3 = v[2]

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
        for x in v1[0]..v2[0]
          for y in [k1*x+m1, k3*x+m3].min..[k1*x+m1, k3*x+m3].max
            colors = [x / (width / 255).to_f, y / (height / 255).to_f, 0]
            for i in 0..2
              maps[0][y * height * 3 + x * 3 + i] = colors[i]
            end
          end
        end
      end
      
      if(v2[0] - v3[0] != 0)
        for x in v2[0]..v3[0]
          for y in [k2*x+m2, k3*x+m3].min..[k2*x+m2, k3*x+m3].max
            colors = [x / (width / 255).to_f, y / (height / 255).to_f, 0]
            for i in 0..2
              maps[0][y * height * 3 + x * 3 + i] = colors[i]
            end
          end
        end
      end
    end
  end
end