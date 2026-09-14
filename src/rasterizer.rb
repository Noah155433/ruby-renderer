require './src/matrix.rb'
require './src/vector.rb'

class Rasterizer

  def initialize(maps, width, height)
    @width = width
    @height = height
    @maps = maps
    @light_pos = Vec3.new(0, 0, 0)
    @camera_pos = Vec3.new(0, 0, 0)
    @ambient_strength = 0.1
    @specular_strength = 0.5
    @fov = 90
  end

  def set_fov(fov)
    @fov = fov
  end

  def set_texture(texture, size)
    @texture = texture
    @texture_size = size
  end

  def set_light_pos(pos)
    @light_pos = pos
  end

  def set_camera_pos(pos)
    @camera_pos = pos
  end

  def set_ambient_strength(strength)
    @ambient_strength = strength
  end

  def set_specular_strength(strength)
    @specular_strength = strength
  end

  def edge(a, b, p)
    return (b.x - a.x) * (p.y - a.y) - (b.y - a.y) * (p.x - a.x)
  end

  def draw_tri(tri_data)

    uv = tri_data.vt

    uv1, uv2, uv3 = uv

    n = 0.1
    f = 200.0

    proj = Matrix.identity

    s = 1 / (Math.tan((@fov / 2) * (Math::PI / 180)))

    proj.set(0, 0, s)
    proj.set(1, 1, s)

    proj.set(2, 2, -(f/(f-n)))
    proj.set(3, 2, -1)
    proj.set(2, 3, -((f*n)/(f-n)))

    v = tri_data.v

    view = Matrix.identity
    view[0][3] = -@camera_pos.x
    view[1][3] = -@camera_pos.y
    view[2][3] = @camera_pos.z

    proj = proj * view

    v1 = v[0]
    v2 = v[1]
    v3 = v[2]

    v1_world, v2_world, v3_world = [v1, v2, v3]

    edge1 = v2_world - v1_world
    edge2 = v3_world - v1_world

    normal = Vec3.new(
      edge1.y * edge2.z - edge1.z * edge2.y,
      edge1.z * edge2.x - edge1.x * edge2.z,
      edge1.x * edge2.y - edge1.y * edge2.x,
    ).normalize

    v1, w1_vert = proj * v1
    v2, w2_vert = proj * v2
    v3, w3_vert = proj * v3

    n_epsilon = 0.0001

    return if w1_vert <= n_epsilon || w2_vert <= n_epsilon || w3_vert <= n_epsilon
    
    v1 = v1 / w1_vert
    v2 = v2 / w2_vert
    v3 = v3 / w3_vert
    
    [v1, v2, v3].each do |vert|
      vert.x = ((vert.x + 1) / 2.to_f) * @width
      vert.y = ((vert.y + 1) / 2.to_f) * @height
    end
    
    min_x = [v1.x, v2.x, v3.x].min
    max_x = [v1.x, v2.x, v3.x].max
    min_y = [v1.y, v2.y, v3.y].min
    max_y = [v1.y, v2.y, v3.y].max
    
    area = edge(v1, v2, v3)
    
    for x in min_x.to_i..max_x.to_i
      for y in min_y.to_i..max_y.to_i

        pixel = Vec3.new(x, y, 0)
        
        w1 = edge(v2, v3, pixel)
        w2 = edge(v3, v1, pixel)
        w3 = edge(v1, v2, pixel)
        
        if w1 <= 0 && w2 <= 0 && w3 <= 0
          
          lam1 = w1 / area
          lam2 = w2 / area
          lam3 = w3 / area
          
          depth = lam1 * v1.z + lam2 * v2.z + lam3 * v3.z

          inv_w1 = 1.0 / w1_vert
          inv_w2 = 1.0 / w2_vert
          inv_w3 = 1.0 / w3_vert

          inv_w = lam1 * inv_w1 + lam2 * inv_w2 + lam3 * inv_w3

          u = (lam1 * uv1.x * inv_w1 + lam2 * uv2.x * inv_w2 + lam3 * uv3.x * inv_w3) / inv_w
          v = (lam1 * uv1.y * inv_w1 + lam2 * uv2.y * inv_w2 + lam3 * uv3.y * inv_w3) / inv_w
          
          tx = (u * (@texture_size[0] - 1)).to_i
          ty = ([(1.0 - v), 0.0].max * (@texture_size[1] - 1)).to_i

          x_world = lam1 * v1_world.x + lam2 * v2_world.x + lam3 * v3_world.x
          y_world = lam1 * v1_world.y + lam2 * v2_world.y + lam3 * v3_world.y
          z_world = lam1 * v1_world.z + lam2 * v2_world.z + lam3 * v3_world.z

          xyz_world = Vec3.new(x_world, y_world, z_world)
          
          lightDir = (@light_pos - xyz_world).normalize

          viewDir = (@camera_pos - xyz_world).normalize

          reflectDir = lightDir.reflect(normal)

          spec = [viewDir.dot(reflectDir), 0.0].max ** 64

          specular = spec * @specular_strength

          diff = [normal.dot(lightDir), 0.0].max

          if (x > 0 && x < @width && y > 0 && y < @height) && @maps[1][y * @width + x] > depth
            @maps[1][y * @width + x] = depth
            for j in 0..2
              value = @texture[ty * 1024 * 3 + tx * 3 + j] * (@ambient_strength + diff + specular)
              #value = depth * 150
              @maps[0][(@height - y).to_i * @width * 3 + x * 3 + j] = value.clamp(0, 255).to_i
            end
          end
        end
      end
    end
  end
end