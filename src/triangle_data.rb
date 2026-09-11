class Tri_data 
  
  def initialize(pa, pb, pc, ta, tb, tc)
    @vertexPos = Array.new(3) {Array.new(3, 0.0)}
    @vertexPos[0] = pa
    @vertexPos[1] = pb
    @vertexPos[2] = pc

    @vertexUV = Array.new(3) {Array.new(2, 0.0)}
    @vertexUV[0] = ta
    @vertexUV[1] = tb
    @vertexUV[2] = tc
  end

  def v
    return @vertexPos
  end

  def vt
    return @vertexUV
  end
end