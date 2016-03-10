require_relative './car'
require_relative './lot'
require_relative './executor'
require_relative './constants'

@lot = nil

def print_response(response)
  print "#{response}\n"
end

def parse_file(file_path)
  File.foreach(file_path).each do |command|
    next if command.strip.empty? # blank line
    print_response(Executor.process_command(command))
  end
end

def init_shell
  while(true) do
    print "> "
    command = STDIN.readline
    begin
      print_response(Executor.process_command(command))
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
