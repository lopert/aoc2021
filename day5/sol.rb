require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(:color => true)]

require 'pry'

class Hydrothermal
  def initialize(input)
    @vents = File.read(input).split("\n").map do |vent|
      HydrothermalVent.new(vent)
    end

  end

  def solve
    @vents = filter_straight(@vents)

    @max_x = @vents.flat_map do |vent|
      [vent.x1, vent.x2]
    end.max + 1

    @max_y = @vents.flat_map do |vent|
      [vent.y1, vent.y2]
    end.max + 1

    result = Array.new(@max_x) do  
      Array.new(@max_y) do
        0
      end
    end
    
    @vents.each do |vent|
      (vent.x1..vent.x2).each do |x|
        (vent.y1..vent.y2).each do |y|
          result[x][y] += 1
        end
      end
    end

    binding.pry
    result.flatten.count { |num| num > 1}

  end

  def filter_straight(vents)
    vents.select do |vent|
      (vent.x1 == vent.x2) || (vent.y1 == vent.y2)
    end
  end

end

class HydrothermalVent

  attr_reader :x1, :x2, :y1, :y2
  def initialize(info)
    debut, fin = info.split(" -> ")
    @x1, @y1 = debut.split(",").map(&:to_i)
    @x2, @y2 = fin.split(",").map(&:to_i)
  end

end

# solver = Hydrothermal.new("./input.txt")
# puts "Part1: #{solver.solve}"
# solver = BingoV2.new("./input.txt")
# puts "Part2: #{solver.solve}"

describe Hydrothermal do
  it "should return 5 for part one example" do
    object_under_test = Hydrothermal.new("./example_input.txt")
    assert_equal 5, object_under_test.solve
  end

  # it "should return 1924 for part two" do
  #   object_under_test = BingoV2.new("./example_input.txt")
  #   assert_equal 1924, object_under_test.solve
  # end
end