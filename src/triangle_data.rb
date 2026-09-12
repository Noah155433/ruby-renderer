require './src/vector.rb'

class Tri_data 
  
  def initialize(pos, normal, uv)
    @vertexPos = Array.new(3) {Vec3.new}
    @vertexPos = pos

    @vertexNormal = Array.new(3) {Vec3.new}
    @vertexNormal = normal

    @vertexUV = Array.new(3) {Vec3.new}
    @vertexUV = uv

  end

  def v
    return @vertexPos
  end

  def vn
    return @vertexNormal
  end

  def vt
    return @vertexUV
  end

end