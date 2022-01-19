require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(:color => true)]

require 'pry'

class Aimer

  def initialize(input)
    @crab_positions = File.read(input).split(",").map(&:to_i).sort
  end

  def solve
    align(function)
  end

  # public just for tests
  def align(target)
    @crab_positions.inject(0) do |sum, pos|
      sum + align_fuel_cost(pos, target)
    end
  end

  private

  # https://www.verywellmind.com/how-to-identify-and-calculate-the-mean-median-or-mode-2795785#toc-median
  def function
    #median
    len = @crab_positions.length
    (@crab_positions[(len - 1) / 2] + @crab_positions[len / 2]) / 2
  end

  def align_fuel_cost(pos, target)
    (pos-target).abs
  end

end

class AimerV2 < Aimer

  private 

  def function
    #average
    (@crab_positions.sum / @crab_positions.length.to_f).round
  end

  def align_fuel_cost(pos, target)
    total = 0
    distance_to_target = (pos-target).abs
    return 0 if distance_to_target == 0
    (1..distance_to_target).each do |cost|
      # binding.pry
      total += cost
    end
    total
  end
end

describe Aimer do
  it "should return 37 for part one example" do
    object_under_test = Aimer.new("./example_input.txt")
    assert_equal 37, object_under_test.solve
  end

  it "should return 41 for part one example" do
    object_under_test = Aimer.new("./example_input.txt")
    assert_equal 41, object_under_test.align(1)
  end

  it "should return 39 for part one example" do
    object_under_test = Aimer.new("./example_input.txt")
    assert_equal 39, object_under_test.align(3)
  end

  it "should return 71 for part one example" do
    object_under_test = Aimer.new("./example_input.txt")
    assert_equal 71, object_under_test.align(10)
  end

  it "should return 168 for part two example" do
    object_under_test = AimerV2.new("./example_input.txt")
    assert_equal 168, object_under_test.solve
  end

  it "should return 206 for part two example" do
    object_under_test = AimerV2.new("./example_input.txt")
    assert_equal 206, object_under_test.align(2)
  end
end

solver = Aimer.new("./input.txt")
puts "Part1: #{solver.solve}"

solver = AimerV2.new("./input.txt")
puts "Part2: #{solver.solve}"

solver = AimerV2.new("./input.txt")
puts "Manual: #{solver.align(466)}"

# 92949057 too high
# Manual aim of 466 is correct at 92948968
# So what's special about the average in this dataset that makes my approach wrong?
# https://www.reddit.com/r/adventofcode/comments/rar7ty/2021_day_7_solutions/hqzwluk/