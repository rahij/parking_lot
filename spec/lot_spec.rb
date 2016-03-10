require 'spec_helper'

LOT_SIZE = 4

describe Lot do
  before :each do
    @lot = Lot.new size: LOT_SIZE
  end

  describe "#new" do
    it "takes size as a parameter returns a Lot object with `size` slots" do
      expect(@lot.size).to eq LOT_SIZE
    end
  end

  describe "#park" do
    car = Car.new plate: "dummy", color: "Black"
    it "assigns the nearest parking slot" do
      current_slot = nil
      (LOT_SIZE).times { current_slot = @lot.park(car: car) }
      expect(current_slot).to eq (LOT_SIZE - 1) # 0 based indexing

      current_slot = @lot.park(car: car)
      expect(current_slot).to be_nil

      @lot.leave(slot: 1)
      current_slot = @lot.park(car: car)
      expect(current_slot).to eq 1
    end
  end
end
