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
    result = Array.new(4, 0.0)
    vec = [vector.x, vector.y, vector.z, 1]
    for i in 0..3
      sum = 0
      for j in 0..3
        sum += @matrix[i][j] * vec[j]
      end
      result[i] = sum
    end
    
    return Vec3.new(result[0], result[1], result[2]), result[3]
  end

  def mul_matrix(matrix)
    result = Array.new(4) {Array.new(4) {0}}
    matrix_array = matrix.get_array
    for i in 0..3
      for j in 0..3
        sum = 0
        for k in 0..3
          sum += @matrix[i][k] * matrix_array[k][j]
        end
        result[i][j] = sum
      end
    end
    return Matrix.new(result)
  end

  def mul_scalar(scalar)
    return @matrix.map { |x| x.map { |y| y * 2}}
  end
end

