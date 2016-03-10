require_relative './car'

class Lot
  attr_reader :cars

  def initialize(size: 1)
    @size = size
    @cars = []
  end

  def park(car:)
    nearest_slot = @cars.size < @size ? @cars.size : @cars.index(&:nil?)
    if nearest_slot.nil?
      return nil
    end
    @cars[nearest_slot] = car
    nearest_slot
  end

  def leave(slot:)
    @cars[slot - 1] = nil
  end

  def to_s
    response = ["Slot No.", "Registration No", "Colour"].join("\t") + "\n";
    response = response + @cars.each_with_index.map do |car, slot_num|
      next if car.nil?
      [slot_num + 1, car.plate, car.color].join("\t")
    end.reject(&:nil?).join("\n")
  end
end
