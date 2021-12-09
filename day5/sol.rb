require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(:color => true)]

require 'pry'

class Hydrothermal
  def initialize(input)
    @vents = File.read(input).split("\n").map do |vent|
      HydrothermalVent.new(vent)
    end
    @grid = generate_grid
  end

  def solve
    mark_grid
    count_grid
  end

  private

  def mark_grid
    straight_vents = @vents.select {|vent| vent.straight?}

    straight_vents.each do |vent|
      x_range = generate_range(vent.x1, vent.x2)
      y_range = generate_range(vent.y1, vent.y2)

      x_range.each do |x|
        y_range.each do |y|
          @grid[x][y] += 1
        end
      end
    end

  end

  def count_grid
    @grid.flatten.count { |num| num > 1}
  end

  def generate_range(a, b) # needed because range doesn't decrement
    return a.upto(b).to_a if a < b
    return a.downto(b).to_a if a > b
    return [a]
  end

  def generate_grid
    @max_x = @vents.flat_map do |vent|
      [vent.x1, vent.x2]
    end.max + 1

    @max_y = @vents.flat_map do |vent|
      [vent.y1, vent.y2]
    end.max + 1

    Array.new(@max_x) do  
      Array.new(@max_y) do
        0
      end
    end
  end

end

class HydrothermalV2 < Hydrothermal

  def mark_grid
    super
    mark_diagonals
  end

  def mark_diagonals
    diagonal_vents = @vents.select {|vent| vent.diagonal?}

    diagonal_vents.each do |vent|
      x_range = generate_range(vent.x1, vent.x2)
      y_range = generate_range(vent.y1, vent.y2)

      # not sure if there's a more rubyesq way to progress through two arrays at the same time
      index = 0
      while index < x_range.length
        @grid[x_range[index]][y_range[index]] += 1
        index+=1
      end
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

  def straight?
    (@x1 == @x2) || (@y1 == @y2)
  end

  def diagonal?
    (@x2 - @x1).abs == (@y2 - @y1).abs
  end
end

solver = Hydrothermal.new("./input.txt")
puts "Part1: #{solver.solve}"
solver = HydrothermalV2.new("./input.txt")
puts "Part2: #{solver.solve}"

describe Hydrothermal do
  it "should return 5 for part one example" do
    object_under_test = Hydrothermal.new("./example_input.txt")
    assert_equal 5, object_under_test.solve
  end

  it "should return 12 for part two" do
    object_under_test = HydrothermalV2.new("./example_input.txt")
    assert_equal 12, object_under_test.solve
  end
end