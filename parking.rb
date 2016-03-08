require_relative './car'
require_relative './lot'

file_path = ARGV[0]
raise 'Provide a file path' unless file_path

@lot = nil

def create_parking_lot(size:)
  @lot = Lot.new(size: size)
end

def park(plate:, color:)
  slot_num = @lot.park(car: Car.new(plate: plate, color: color))
  if slot_num.nil?
    p "Sorry, parking lot is full"
  else
    p "Allocated slot number: #{slot_num + 1}"
  end
end

def leave(slot:)
  @lot.leave(slot: slot)
  p "Slot number #{slot} is free"
end

def status
  p @lot.to_s
end

def registration_numbers_for_cars_with_colour(color:)
  p @lot.slots.select {|slot| slot.color == color}.map(&:plate).join(", ")
end

def slot_numbers_for_cars_with_colour(color:)
  p (@lot.slots.each_index.select {|i| @lot.slots[i].color == color}.map do |idx|
    idx + 1
  end).join(", ")
end

def slot_number_for_registration_number(plate:)
  slot_num = @lot.slots.index {|slot| slot.plate == plate}
  slot_num = slot_num + 1 unless slot_num.nil?
  p slot_num
end

File.foreach(file_path).each do |command|
  next if command.strip.empty?

  tokens = command.strip.split

  case tokens.first
  when 'create_parking_lot'
    raise 'Please provide a valid number of slots in the lot' unless (tokens[1].to_i > 0)
    create_parking_lot(size: tokens[1].to_i)
  when 'park'
    raise 'Please provide a car number and and color' unless tokens.size >= 3
    park(plate: tokens[1], color: tokens[2])
  when 'leave'
    raise 'Please provide a valid slot number' unless (tokens[1].to_i > 0)
    leave(slot: tokens[1].to_i)
  when 'status'
    status
  when 'registration_numbers_for_cars_with_colour'
    raise 'Please provide a color' unless tokens.size >= 2
    registration_numbers_for_cars_with_colour(color: tokens[1])
  when 'slot_numbers_for_cars_with_colour'
    raise 'Please provide a color' unless tokens.size >= 2
    slot_numbers_for_cars_with_colour(color: tokens[1])
  when 'slot_number_for_registration_number'
    raise 'Please provide a color' unless tokens.size >= 2
    slot_number_for_registration_number(plate: tokens[1])
  else
    raise 'Invalid Command'
  end
end
status
