require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(:color => true)]

class BinDiag

  def solve(input_file)
    numbers = File.read(input_file).split("\n")
    numbers_in_positions = count_numbers_in_positions(numbers)
    gamma(numbers_in_positions) * epsilon(numbers_in_positions)
  end

  private

  def count_numbers_in_positions(numbers)

    # https://stackoverflow.com/questions/9108619/if-key-does-not-exist-create-default-value
    # result = Hash.new do |hash, key|
    #   hash[key] = {
    #     "0" => 0,
    #     "1" => 0
    #   }
    # end

    # https://www.rubydoc.info/stdlib/core/Array:initialize
    # decided to go with an array as the top level container since order matters
    result = Array.new(numbers.first.length) do  
      {
        "0" => 0,
        "1" => 0
      }
    end

    numbers.each do |number|
      number.chars.each_with_index do |char, index|
        result[index][char] += 1
      end
    end

    result
  end

  # https://stackoverflow.com/questions/6040494/how-to-find-the-key-of-the-largest-value-hash
  # https://apidock.com/ruby/Enumerable/max_by
  def gamma(numbers_in_positions)
    numbers_in_positions.map do |counts|
      max = counts.max_by {|k,v| v}.last
      filter_counts(counts, max)
        .sort
        .reverse[0] # tiebreak goes to 1
    end.join.to_i(2) # convert to decimal
  end

  def epsilon(numbers_in_positions)
    numbers_in_positions.map do |counts|
      min = counts.min_by {|k,v| v}.last
     filter_counts(counts, min)
       .sort[0] # tiebreak goes to 0
    end.join.to_i(2) # convert to decimal
  end

  def filter_counts(counts, value)
    counts.select {|k,v| v == value}.keys
  end
end

class BinDiagV2 < BinDiag

  def solve(input_file)
    numbers = File.read(input_file).split("\n")
    oxygen_generator_rating(numbers) * co2_scrubber_rating(numbers)
  end

  private

  def rating(numbers, type)
    position = 0
    while numbers.size > 1 do 
      current_column = numbers.map do |number| # get the numbers in the first, second, etc. position
        number.chars[position]
      end

      numbers_in_positions = count_numbers_in_positions(current_column)

      numbers = numbers.select do |number| # remove numbers that do not match the bit criteria
        number.chars[position].to_i == send(type, numbers_in_positions) # calls gamma or epsilon for bit criteria to compare
      end

      # is there a loop with condition plus an iteration counter? 
      # couldn't find one so manually keeping track of the columns
      position += 1 
    end
    
    numbers
      .first # there will only be 1 number in our array
      .to_i(2) # convert to decimal from base2
  end

  def oxygen_generator_rating(numbers)
    rating(numbers, "gamma")
  end

  def co2_scrubber_rating(numbers)
    rating(numbers, "epsilon")
  end

end

solver = BinDiag.new()
puts "Part1: #{solver.solve("./input.txt")}"
solver = BinDiagV2.new()
puts "Part2: #{solver.solve("./input.txt")}"

describe BinDiag do
  it "should return 198 for part one" do
    object_under_test = BinDiag.new()
    assert_equal 198, object_under_test.solve("./example_input.txt")
  end

  it "should return 230 for part two" do
    object_under_test = BinDiagV2.new()
    assert_equal 230, object_under_test.solve("./example_input.txt")
  end
end