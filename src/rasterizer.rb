require './src/matrix.rb'

class Rasterizer

  def self.edge(a, b, p)
    return (b[0] - a[0]) * (p[1] - a[1]) - (b[1] - a[1]) * (p[0] - a[0])
  end

  def self.draw_tri(tri_data, maps, width, height, texture, tex_data)

    color_format = [0, 1, 2]

    uv = tri_data.vt

    uv1, uv2, uv3 = uv

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
    view.set(2, 3, -1)

    proj.dot_matrix!(view)

    v1 = proj.dot_vector(v[0])
    v2 = proj.dot_vector(v[1])
    v3 = proj.dot_vector(v[2])

    v1 = v1.map { |c| c / v1[3]}
    v2 = v2.map { |c| c / v2[3]}
    v3 = v3.map { |c| c / v3[3]}
    
    [v1, v2, v3].each do |vert|
      vert[0] = ((vert[0] + 1) / 2) * width
      vert[1] = ((vert[1] + 1) / 2) * height
    end

    min_x = [v1[0], v2[0], v3[0]].min
    max_x = [v1[0], v2[0], v3[0]].max
    min_y = [v1[1], v2[1], v3[1]].min
    max_y = [v1[1], v2[1], v3[1]].max
    
    area = edge(v1, v2, v3)

    color = [rand(255), rand(255), rand(255)]

    for x in min_x.to_i..max_x.to_i
      for y in min_y.to_i..max_y.to_i
        pixel = [x, y]

        w1 = edge(v2, v3, pixel)
        w2 = edge(v3, v1, pixel)
        w3 = edge(v1, v2, pixel)

        if w1 <= 0 && w2 <= 0 && w3 <= 0

          lam1 = w1 / area
          lam2 = w2 / area
          lam3 = w3 / area

          depth = lam1 * v1[2] + lam2 * v2[2] + lam3 * v3[2]

          u = lam1 * uv1[0] + lam2 * uv2[0] + lam3 * uv3[0]
          v = lam1 * uv1[1] + lam2 * uv2[1] + lam3 * uv3[1]

          tx = (u * (tex_data[0] - 1)).to_i
          ty = ((1.0 - v) * (tex_data[1] - 1)).to_i

          if(maps[1][y * width + x] > depth)
            maps[1][y * width + x] = depth
            for j in 0..2
              maps[0][y * width * 3 + x * 3 + color_format[j]] = texture[ty * 1024 * 3 + tx * 3 + j]
            end
          end
        end
      end
    end
  end
end