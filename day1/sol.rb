require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(:color => true)]

class SonarDepthIncreaseCounter

  def initialize(input_file)
    @input = File.read(input_file).split
  end

  # https://www.honeybadger.io/blog/how-ruby-ampersand-colon-works/
  # https://medium.com/@soni.dumitru/the-each-cons-method-in-ruby-c2a4af937ecf
  # https://apidock.com/ruby/Enumerable/count

  def solve_part_one
    @input.map(&:to_i)
      .each_cons(2) # grab every consecutive pair
      .count do |depths| # count each of these pairs...
        depths[0] < depths[1] # ... that match this condition
      end
  end

  def solve_part_two
    @input.map(&:to_i)
      .each_cons(3) # grab every consecutiple triple
      .map(&:sum) # calculate their sums
      .each_cons(2) # grab every consecutive pair of sums
      .count do |sums| # count each of these pairs...
        sums[0] < sums[1] # ... that match this condition
      end
  end
end

solver = SonarDepthIncreaseCounter.new("./input.txt")
puts "Part1: #{solver.solve_part_one}"
puts "Part2: #{solver.solve_part_two}"

describe SonarDepthIncreaseCounter do
  object_under_test = SonarDepthIncreaseCounter.new("./example_input.txt")
  it "should return 7 for part one" do
    assert_equal 7, object_under_test.solve_part_one
  end

  it "should return 5 for part two" do
    assert_equal 5, object_under_test.solve_part_two
  end
end