require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(:color => true)]

class Submarine

  def initialize
    @horizontal_position = 0
    @depth = 0
  end

  def solve(input_file)
    @instructions = File.read(input_file).split("\n")
    process_instructions
    return @horizontal_position * @depth
  end

  private

  def process_instructions
    @instructions.each do |instruction| 
      direction, magnitude = parse(instruction)
      perform_instruction(direction, magnitude)
    end
  end

  def perform_instruction(direction, magnitude)    
    case direction
    when "forward"
      @horizontal_position += magnitude
    when "down"
      @depth += magnitude
    when "up"
      @depth -= magnitude
    else
      raise StandardError
    end
  end

  def parse(instruction)
    result = instruction.split
    result[1] = result[1].to_i
    result
  end
end

class SubmarineV2 < Submarine
  def initialize
    @aim = 0
    super
  end

  private

  def perform_instruction(direction, magnitude)    
    case direction
    when "forward"
      super
      @depth += @aim * magnitude
    when "down"
      @aim += magnitude
    when "up"
      @aim -= magnitude
    else
      raise StandardError
    end
  end
end

solver = Submarine.new()
puts "Part1: #{solver.solve("./input.txt")}"
solver = SubmarineV2.new()
puts "Part2: #{solver.solve("./input.txt")}"

describe Submarine do
  it "should return 150 for part one" do
    object_under_test = Submarine.new()
    assert_equal 150, object_under_test.solve("./example_input.txt")
  end

  it "should return 900 for part two" do
    object_under_test = SubmarineV2.new()
    assert_equal 900, object_under_test.solve("./example_input.txt")
  end
end