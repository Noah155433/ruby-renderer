class Vec3
  attr_reader :x, :y, :z

  def initialize(x = 0.0, y = 0.0, z = 0.0)
    @x = x.to_f
    @y = y.to_f
    @z = z.to_f
  end

  def x=(x)
    @x = x
  end

  def y=(y)
    @y = y
  end

  def z=(z)
    @z = z
  end

  def +(other)
    Vec3.new(@x + other.x, @y + other.y, @z + other.z)
  end

  def -(other)
    Vec3.new(@x - other.x, @y - other.y, @z - other.z)
  end

  def *(scalar)
    Vec3.new(@x * scalar, @y * scalar, @z * scalar)
  end

  def /(scalar)
    Vec3.new(@x / scalar, @y / scalar, @z / scalar)
  end

  def dot(other)
    @x * other.x + @y * other.y + @z * other.z
  end

  def reflect(normal)
    normal * (2.0 * normal.dot(self)) - self
  end

  def cross(other)
    Vec3.new(
      @y * other.z - @z * other.y,
      @z * other.x - @x * other.z,
      @x * other.y - @y * other.x
    )
  end

  def length
    Math.sqrt(dot(self))
  end

  def normalize
    len = length
    return Vec3.new if len.zero?

    Vec3.new(@x / len, @y / len, @z / len)
  end
end