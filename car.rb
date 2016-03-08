class Car
  attr_reader :plate, :color

  def initialize(plate:, color:)
    @plate = plate
    @color = color
  end
end
