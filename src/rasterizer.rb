require './src/matrix.rb'
require './src/vector.rb'

class Rasterizer

  def initialize(maps, width, height)
    @width = width
    @height = height
    @maps = maps
    @light_pos = Vec3.new(0, 0, 0)
    @camera_pos = Vec3.new(0, 0, 0)
    @world_ambient_strength = 0.7
    @ambient_strength = 0.1
    @specular_strength = 0.5
    @fov = 90
    @kc = 1
    @kl = 0.35
    @kq = 0.44
    @object_matrix = Matrix.identity
    @view_matrix = Matrix.identity
    update_proj_matrix
    update_view_matrix

    
  end

  def set_object_matrix(matrix)
    @object_matrix = matrix
  end

  def update_proj_matrix()
    n = 0.1
    f = 200.0

    @proj = Matrix.identity

    s = 1 / (Math.tan((@fov / 2) * (Math::PI / 180)))

    @proj.set(0, 0, s)
    @proj.set(1, 1, s)

    @proj.set(2, 2, -(f / (f - n)))
    @proj.set(2, 3, -1)
    @proj.set(3, 2, -((f * n) / (f - n)))
    @proj.set(3, 3, 0)
  end
  
  def update_view_matrix()
    @view = Matrix.identity
    @view.set(3, 0, -@camera_pos.x)
    @view.set(3, 1, -@camera_pos.y)
    @view.set(3, 2, -@camera_pos.z)
  end
  
  def set_fov(fov)
    @fov = fov
    update_proj_matrix
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
    update_view_matrix
  end
  
  def set_ambient_strength(strength)
    @ambient_strength = strength
  end
  
  def set_world_ambient_strength(strength)
    @world_ambient_strength = strength
  end
  
  def set_specular_strength(strength)
    @specular_strength = strength
  end
  
  def area_of_triangle(a, b, p)
    return (b.x - a.x) * (p.y - a.y) - (b.y - a.y) * (p.x - a.x)
  end
  
  def draw_tri(tri_data)
    
    #Get vertex UV coordinates from tri_data
    uv = tri_data.vt
    
    #Split uv coordinates into their respective vertices
    uv1, uv2, uv3 = uv
    
    #Get vertex coordinates from tri_data
    v = tri_data.v
    
    #Assign the three vertices to their own variables 
    v1, v2, v3 = v
    
    #Assign vx_world to the vertex coordinate in world space, wx will be replaced when multiplication with the projection matrix is done but is needed to parse output
    (v1_world, x), (v2_world, x), (v3_world, x) = [ @object_matrix * v1, @object_matrix * v2, @object_matrix * v3]

    #Get the vector of two of the edges of the triangle through vector subtraction
    edge1 = v2_world - v1_world
    edge2 = v3_world - v1_world

    #Use edges to create the normal direction of the face
    normal = Vec3.new(
      edge1.y * edge2.z - edge1.z * edge2.y,
      edge1.z * edge2.x - edge1.x * edge2.z,
      edge1.x * edge2.y - edge1.y * edge2.x,
    ).normalize

    # Transform world position into view space, then view space into clip space
    v1_view, w1_view = @view * v1_world
    v2_view, w2_view = @view * v2_world
    v3_view, w3_view = @view * v3_world

    v1, w1_vert = @proj * v1_view
    v2, w2_vert = @proj * v2_view
    v3, w3_vert = @proj * v3_view

    #Brutally and ruthlessly clip the entire triangles if a single vertex is too close to the camera
    return if w1_vert <= 0.00001 || w2_vert <= 0.00001 || w3_vert <= 0.00001

    #Divide the vertices by their distance from the camera to make closer objects appears bigger
    v1 = v1 / w1_vert
    v2 = v2 / w2_vert
    v3 = v3 / w3_vert
    
    #Translate from clip space to screen space
    [v1, v2, v3].each do |vert|
      vert.x = ((vert.x + 1) / 2.to_f) * @width
      vert.y = ((vert.y + 1) / 2.to_f) * @height
    end
    
    #Get the lower and higher bounds of the triangle
    min_x = [v1.x, v2.x, v3.x].min
    max_x = [v1.x, v2.x, v3.x].max
    min_y = [v1.y, v2.y, v3.y].min
    max_y = [v1.y, v2.y, v3.y].max
    
    #Get the area of the triangle
    area = area_of_triangle(v1, v2, v3)
    
    #Loop through the bounds of the triangle in screen space
    for x in min_x.to_i..max_x.to_i
      for y in min_y.to_i..max_y.to_i
        
        #get the current pixel as a Vec3
        pixel = Vec3.new(x, y, 0)
        
        #Use the area of triangle function to check if the pixel is on the right side of the triangles sides. If the value returned is negative, the pixel is to the right of the triangle
        w1 = area_of_triangle(v2, v3, pixel)
        w2 = area_of_triangle(v3, v1, pixel)
        w3 = area_of_triangle(v1, v2, pixel)
        
        #Check if the pixel is to the right of all the sides of the triangle, aka inside the triangle
        if w1 <= 0 && w2 <= 0 && w3 <= 0
          
          #divide w1, w2, and w3, which are the distances between the pixel and each respective vertex by the area to get three distances that sum up to one that can be used to determine how much control each vertex should have over the fragment
          lam1 = w1 / area
          lam2 = w2 / area
          lam3 = w3 / area
          
          #use the barycentric coordinates to determine how much each vertex's depth should contribute to the fragments depth to get the actual depth fo the fragment
          depth = lam1 * v1.z + lam2 * v2.z + lam3 * v3.z

          #Check that the fragment is within the bounds of the screen and in front of any other fragments that have been drawn so far
          if (x >= 0 && x < @width && y >= 0 && y < @height) && @maps[1][y * @width + x] > depth

            #Since barycentric coordinate calculation happens in screen space, using them for things like UV or lighting would cause extreme warping
            #Therefore we calculate 1/wx_vert to determine how much that vertice has shrunk when turned from world space to clip space.
            #Eg. if we have a plane the two further vertices will have a further depth (w) and when we divide 1 by the depth we get how much it was shrunk by
            #We can use this to fix reverse the warping
            inv_w1 = 1.0 / w1_vert
            inv_w2 = 1.0 / w2_vert
            inv_w3 = 1.0 / w3_vert

            #Use the inverse wx's and the barycentric coordinates to get the amount the exact fragment has been warped
            inv_w = lam1 * inv_w1 + lam2 * inv_w2 + lam3 * inv_w3
            
            #Multiply each vertex attribute with it's own inv_wx to turn it from screen space to depth space.
            #Determine how much each of the vertexes should contribute to the final weight and multiply their values
            #Use inv_w to undo the depth distortion to remove the warping
            u = (lam1 * uv1.x * inv_w1 + lam2 * uv2.x * inv_w2 + lam3 * uv3.x * inv_w3) / inv_w
            v = (lam1 * uv1.y * inv_w1 + lam2 * uv2.y * inv_w2 + lam3 * uv3.y * inv_w3) / inv_w

            #Turn the UV coordinates into index's for the Texture and flip y as vips loads the images upside down
            tx = (u * (@texture_size[0] - 1)).to_i
            ty = ([(1.0 - v), 0.0].max * (@texture_size[1] - 1)).to_i

            #Same approach as the UV coordinates but used to get the fragments position in world space
            x_world = (lam1 * v1_world.x * inv_w1 + lam2 * v2_world.x * inv_w2 + lam3 * v3_world.x * inv_w3) / inv_w
            y_world = (lam1 * v1_world.y * inv_w1 + lam2 * v2_world.y * inv_w2 + lam3 * v3_world.y * inv_w3) / inv_w
            z_world = (lam1 * v1_world.z * inv_w1 + lam2 * v2_world.z * inv_w2 + lam3 * v3_world.z * inv_w3) / inv_w

            #Combine the x y and z world coordinates of the fragment
            xyz_world = Vec3.new(x_world, y_world, z_world)
            
            #Get the direction from the fragment to the light source
            lightDir = (@light_pos - xyz_world).normalize

            #Get the direction form the fragment to the camera position
            viewDir = (@camera_pos - xyz_world).normalize

            #Get the direction of reflection between the direction of the light and the normal
            reflectDir = lightDir.reflect(normal)

            #Get the specular direction by dot multiplying the direction from the fragment to the camera and the reflected direction of light
            spec = [viewDir.dot(reflectDir), 0.0].max ** 64

            #Multiply the specular by the specular strength
            specular = spec * @specular_strength

            #Get the diffuse lighting by dot multiplying the direction of the light from the fragment with the normal of the surface
            diff = [normal.dot(lightDir), 0.0].max

            #Get the distance from the fragment to the light source
            distance = (@light_pos - xyz_world).length
            #Get the attenuation (strength as a function of distace) of the light
            attenuation = 1 / (@kc + @kl * distance + @kq * (distance**2))

            #Multiply all three types of light with the attenuation
            ambient = @ambient_strength * attenuation
            diff *= attenuation
            specular *= attenuation

            #Update the depth buffer
            @maps[1][y * @width + x] = depth

            #Draw the color of the texture into the color buffer
            for j in 0..2
              #Get the color color of the texture at the UV index and multiply it with the different types of light
              value = @texture[ty * @texture_size[0] * 3 + tx * 3 + j] * (ambient + diff + specular)
              #Draw to the color buffer
              @maps[0][(@height - y).to_i * @width * 3 + x * 3 + j] = value.clamp(0, 255).to_i
            end
          end
        end
      end
    end
  end
end