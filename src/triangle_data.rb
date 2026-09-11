class Tri_data 
  
  def initialize(pos, normal, uv)
    @vertexPos = Array.new(3) {Array.new(3, 0.0)}
    @vertexPos = pos[0, 3]

    @vertexNormal = Array.new(3) {Array.new(3, 0.0)}
    @vertexNormal = normal

    @vertexUV = Array.new(3) {Array.new(2, 0.0)}
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