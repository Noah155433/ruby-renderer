class Tri_data 
  
  def initialize(a, b, c)
    @vertexPos = Array.new(3) {Array.new(3, 0.0)}
    @vertexPos[0] = a
    @vertexPos[1] = b
    @vertexPos[2] = c 
  end

  def v
    return @vertexPos
  end
end