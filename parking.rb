require_relative './car'
require_relative './lot'
require_relative './constants'

@lot = nil

def create_parking_lot(size:)
  @lot = Lot.new(size: size)
  "Created a parking lot with #{size} slots"
end

def park(plate:, color:)
  slot_num = @lot.park(car: Car.new(plate: plate, color: color))
  if slot_num.nil?
    PARKING_FULL_ERROR
  else
    "Allocated slot number: #{slot_num + 1}"
  end
end

def leave(slot:)
  @lot.leave(slot: slot)
  "Slot number #{slot} is free"
end

def status
  @lot.to_s
end

def registration_numbers_for_cars_with_colour(color:)
  @lot.cars.select {|slot| slot.color == color}.map(&:plate).join(", ")
end

def slot_numbers_for_cars_with_colour(color:)
  (@lot.cars.each_index.select {|i| @lot.cars[i].color == color}.map do |idx|
    idx + 1
  end).join(", ")
end

def slot_number_for_registration_number(plate:)
  slot_num = @lot.cars.index {|slot| slot.plate == plate}
  if slot_num.nil?
    "Not found"
  else
    slot_num + 1
  end
end

def parse_and_execute(tokens)
  case tokens.first

  when 'create_parking_lot'
    raise ArgumentError, INVALID_NUM_SLOTS_ERROR unless (tokens[1].to_i > 0)
    create_parking_lot(size: tokens[1].to_i)

  when 'park'
    raise ArgumentError, EMPTY_PLATE_NUMBER_COLOR_ERROR unless tokens.size >= 3
    park(plate: tokens[1], color: tokens[2])

  when 'leave'
    raise ArgumentError, INVALID_SLOT_NUMBER_ERROR unless (tokens[1].to_i > 0)
    leave(slot: tokens[1].to_i)

  when 'status'
    status

  when 'registration_numbers_for_cars_with_colour'
    raise ArgumentError, EMPTY_COLOR_ERROR unless tokens.size >= 2
    registration_numbers_for_cars_with_colour(color: tokens[1])

  when 'slot_numbers_for_cars_with_colour'
    raise ArgumentError, EMPTY_COLOR_ERROR unless tokens.size >= 2
    slot_numbers_for_cars_with_colour(color: tokens[1])

  when 'slot_number_for_registration_number'
    raise ArgumentError, EMPTY_COLOR_ERROR unless tokens.size >= 2
    slot_number_for_registration_number(plate: tokens[1])

  else
    raise ArgumentError, INVALID_COMMAND_ERROR
  end
end

def print_response(response)
  print "#{response}\n"
end

def process_command(command)
  tokens = command.strip.split
  response = parse_and_execute(tokens)
  print_response(response)
end

def parse_file(file_path)
  File.foreach(file_path).each do |command|
    next if command.strip.empty? # blank line
    process_command(command)
  end
end

def init_shell
  while(true) do
    print "> "
    command = STDIN.readline
    begin
      process_command(command)
    rescue ArgumentError => e
      print_response(e.message)
    end
  end
end

file_path = ARGV[0]
if file_path
  parse_file(file_path)
else
  init_shell
end
