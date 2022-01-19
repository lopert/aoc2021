require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(:color => true)]

require 'pry'

class Lanternfish
  attr_reader :spawn_timer

  def initialize(timer=8)
    @spawn_timer = timer
  end

  def advance
    @spawn_timer -= 1
    spawn if @spawn_timer < 0
  end

  def spawn
    @spawn_timer = 6
    Lanternfish.new
  end
end

class Fishes
  def initialize(input)
    @fishes = File.read(input).split(",").map do |timer|
      Lanternfish.new(timer.to_i)
    end
  end

  def solve(days=80)
    # print_state(0)
    (1..days).each do |day|
      progress_day
      # print_state(day)
    end
    result
  end

  private
  
  def progress_day
    new_fishes = []
    @fishes.each do |fish|
      new_fish = fish.advance
      new_fishes << new_fish if new_fish
    end
    @fishes = @fishes.concat new_fishes
  end

  def result
    @fishes.count
  end

  def print_state(day)
    timers = @fishes.map do |fish|
      fish.spawn_timer
    end

    puts "After #{day} day#{"s" if day != 1}: #{timers.join(",")}"
  end
end

# Inspired from: https://cestlaz.github.io/post/advent-2021-day06/
class FishesV2 < Fishes
  def initialize(input)
    super
    @num_fishes_per_day = fishes_to_days
  end

  private

  def result
    @fishes_per_day.sum
  end

  def progress_day
    num_fishes = @num_fishes_per_day.shift
    @num_fishes_per_day << num_fishes
    @num_fishes_per_day[6] += num_fishes
  end

  # track how many fish will spawn on each day
  def fishes_to_days
    array = Array.new(9,0) # 0 is the final value before tick over, leading to 9 states
    @fishes.each do |fish|
      array[fish.spawn_timer] += 1
    end
    array
  end
end

describe Fishes do
  it "should return 26 for part one example" do
    object_under_test = Fishes.new("./example_input.txt")
    assert_equal 26, object_under_test.solve(18)
  end

  it "should return 5394 for part one example" do
    object_under_test = Fishes.new("./example_input.txt")
    assert_equal 5934, object_under_test.solve
  end

  it "should return 26984457539 for part two example" do
    object_under_test = FishesV2.new("./example_input.txt")
    assert_equal 26984457539, object_under_test.solve(256)
  end
end

solver = Fishes.new("./input.txt")
puts "Part1: #{solver.solve}"

solver = FishesV2.new("./input.txt")
puts "Part2: #{solver.solve(256)}"