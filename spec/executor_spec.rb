require 'spec_helper'
require_relative '../executor.rb'

LOT_SIZE = 4

describe Executor do
  describe 'parse' do
    it "should call the correct method for each command" do
      expect(Executor).to receive(:create_parking_lot).with(size: LOT_SIZE)
      Executor.process_command("create_parking_lot #{LOT_SIZE}")

      expect(Executor).to receive(:status)
      Executor.process_command("status")

      expect(Executor).to receive(:park).with(plate: "dummy_plate", color: "dummy_color")
      Executor.process_command("park dummy_plate dummy_color")

      expect(Executor).to receive(:leave).with(slot: 1)
      Executor.process_command("leave 1")

      expect(Executor).to receive(:registration_numbers_for_cars_with_colour).with(color: "dummy_color")
      Executor.process_command("registration_numbers_for_cars_with_colour dummy_color")

      expect(Executor).to receive(:slot_numbers_for_cars_with_colour).with(color: "dummy_color")
      Executor.process_command("slot_numbers_for_cars_with_colour dummy_color")

      expect(Executor).to receive(:slot_number_for_registration_number).with(plate: "dummy_plate")
      Executor.process_command("slot_number_for_registration_number dummy_plate")
    end
  end

  describe 'execute' do
    before :each do
      Executor.process_command("create_parking_lot 4")
    end
    it "should return the correct registration numbers for a color" do
      Executor.process_command("park plate1 color1")
      Executor.process_command("park plate2 color1")
      Executor.process_command("park plate3 color2")
      expect(
        Executor.process_command("registration_numbers_for_cars_with_colour color1")
      ).to eq "plate1, plate2"
      expect(
        Executor.process_command("registration_numbers_for_cars_with_colour color10")
      ).to eq ""
    end

    it "should return the correct slot numbers for a color" do
      Executor.process_command("park plate1 color1")
      Executor.process_command("park plate2 color2")
      Executor.process_command("park plate3 color1")
      expect(
        Executor.process_command("slot_numbers_for_cars_with_colour color1")
      ).to eq "1, 3"
      expect(
        Executor.process_command("slot_numbers_for_cars_with_colour color10")
      ).to eq ""
    end

    it "should return the correct slot number for a registration number" do
      Executor.process_command("park plate1 color1")
      Executor.process_command("park plate2 color2")
      Executor.process_command("park plate3 color1")
      expect(
        Executor.process_command("slot_number_for_registration_number plate2")
      ).to eq "2"
      expect(
        Executor.process_command("slot_number_for_registration_number plate10")
      ).to eq "Not found"
    end
  end
end
