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

  def set(i, j, n)
    @matrix[i][j] = n 
  end

  def get_index(i, j)
    return @matrix[i][j]
  end

  def get_array()
    return @matrix
  end

  def dot_vector(vector)
    result = Array.new(4, 0.0)
    vector[3] = 1
    for i in 0..3
      sum = 0
      for j in 0..3
        sum += @matrix[i][j] * vector[j]
      end
      result[i] = sum
    end
    
    return result
  end

  def dot_matrix!(matrix)
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
    @matrix = result
  end
end

