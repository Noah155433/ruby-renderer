require './src/vector.rb'

class Matrix

  def initialize(c)
    @matrix = c
  end

  def self.identity()
    return Matrix.new([
      [1, 0, 0, 0],
      [0, 1, 0, 0],
      [0, 0, 1, 0],
      [0, 0, 0, 1]
  ])
  end

  def [] (x)
    @matrix[x]
  end

  def set(i, j, n)
    @matrix[i][j] = n 
  end

  def get_index(i, j)
    return @matrix[i][j]
  end

  def get_array()
    return @matrix
  end

  def *(other)

    case other
    when Vec3
      return mul_vector(other)
    when Matrix
      return mul_matrix(other)
    when Float
      return mul_scalar(other)
    when Integer
      return mul_scalar(other.to_f)
    else
      puts "Cannot perform multiplication between matrix and #{other.class}"
      abort
    end
  end

  def mul_vector(vector)
    vx, vy, vz = vector.x, vector.y, vector.z

    rx = @matrix[0][0] * vx + @matrix[1][0] * vy + @matrix[2][0] * vz + @matrix[3][0]
    ry = @matrix[0][1] * vx + @matrix[1][1] * vy + @matrix[2][1] * vz + @matrix[3][1]
    rz = @matrix[0][2] * vx + @matrix[1][2] * vy + @matrix[2][2] * vz + @matrix[3][2]
    rw = @matrix[0][3] * vx + @matrix[1][3] * vy + @matrix[2][3] * vz + @matrix[3][3]
    
    return Vec3.new(rx, ry, rz), rw
  end

  def mul_matrix(matrix)
    vxx, vxy, vxz, vxw = matrix[0][0], matrix[0][1], matrix[0][2], matrix[0][3]
    vyx, vyy, vyz, vyw = matrix[1][0], matrix[1][1], matrix[1][2], matrix[1][3]
    vzx, vzy, vzz, vzw = matrix[2][0], matrix[2][1], matrix[2][2], matrix[2][3]
    vwx, vwy, vwz, vww = matrix[3][0], matrix[3][1], matrix[3][2], matrix[3][3]

    rxx = @matrix[0][0] * vxx + @matrix[0][1] * vyx + @matrix[0][2] * vzx + @matrix[0][3] * vwx
    rxy = @matrix[0][0] * vxy + @matrix[0][1] * vyy + @matrix[0][2] * vzy + @matrix[0][3] * vwy
    rxz = @matrix[0][0] * vxz + @matrix[0][1] * vyz + @matrix[0][2] * vzz + @matrix[0][3] * vwz
    rxw = @matrix[0][0] * vxw + @matrix[0][1] * vyw + @matrix[0][2] * vzw + @matrix[0][3] * vww

    ryx = @matrix[1][0] * vxx + @matrix[1][1] * vyx + @matrix[1][2] * vzx + @matrix[1][3] * vwx
    ryy = @matrix[1][0] * vxy + @matrix[1][1] * vyy + @matrix[1][2] * vzy + @matrix[1][3] * vwy
    ryz = @matrix[1][0] * vxz + @matrix[1][1] * vyz + @matrix[1][2] * vzz + @matrix[1][3] * vwz
    ryw = @matrix[1][0] * vxw + @matrix[1][1] * vyw + @matrix[1][2] * vzw + @matrix[1][3] * vww

    rzx = @matrix[2][0] * vxx + @matrix[2][1] * vyx + @matrix[2][2] * vzx + @matrix[2][3] * vwx
    rzy = @matrix[2][0] * vxy + @matrix[2][1] * vyy + @matrix[2][2] * vzy + @matrix[2][3] * vwy
    rzz = @matrix[2][0] * vxz + @matrix[2][1] * vyz + @matrix[2][2] * vzz + @matrix[2][3] * vwz
    rzw = @matrix[2][0] * vxw + @matrix[2][1] * vyw + @matrix[2][2] * vzw + @matrix[2][3] * vww
    
    rwx = @matrix[3][0] * vxx + @matrix[3][1] * vyx + @matrix[3][2] * vzx + @matrix[3][3] * vwx
    rwy = @matrix[3][0] * vxy + @matrix[3][1] * vyy + @matrix[3][2] * vzy + @matrix[3][3] * vwy
    rwz = @matrix[3][0] * vxz + @matrix[3][1] * vyz + @matrix[3][2] * vzz + @matrix[3][3] * vwz
    rww = @matrix[3][0] * vxw + @matrix[3][1] * vyw + @matrix[3][2] * vzw + @matrix[3][3] * vww

    return Matrix.new([
      [rxx, rxy, rxz, rxw],
      [ryx, ryy, ryz, ryw],
      [rzx, rzy, rzz, rzw],
      [rwx, rwy, rwz, rww]
    ])

  end

  def mul_scalar(scalar)
    return @matrix.map { |x| x.map { |y| y * scalar}}
  end
end

