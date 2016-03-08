require_relative './car'

class Lot
  attr_reader :slots

  def initialize(size: 1)
    @size = size
    @slots = []
  end

  def park(car:)
    nearest_slot = @slots.size < @size ? @slots.size : @slots.index(&:nil?)
    if nearest_slot.nil?
      return nil
    end
    @slots[nearest_slot] = car
    nearest_slot
  end

  def leave(slot:)
    @slots[slot - 1] = nil
  end

  def to_s
    @slots
  end
end
