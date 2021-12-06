require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(:color => true)]

require 'pry'

class Bingo

  def initialize(input_file)
    input = File.read(input_file).split("\n\n")

    @called_numbers = input.shift.split(",")
    
    @cards = input.map do |card|
      BingoCard.new(card)
    end

    solve

    binding.pry
    
    
  end

  def solve
    @called_numbers.each do |called_number|
      @cards.each do |card|
        card.mark(called_number)
      end

      break if @cards.map do |card|
        binding.pry if card.winner?

        card.winner?
      end.include?(true)
    end
  end

  private

end

class BingoCard
  def initialize(card)
    @card = card.split("\n").map do |line|
      line.split(" ").map do |number|
        number
      end
    end
  end

  def mark(number)
    @card.each_with_index do |row, index|
      pos = row.index(number)
      if pos
        @card[index][pos] += "M" if pos
        return
      end
    end
  end

  def winner?
    check_rows
  end

  def check_rows
    @card.each do |row|
      row.each do |number|
        puts number
        binding.pry if number.include?("22M")
        return false unless number.include?("M")
        # binding.pry
      end
    end
    binding.pry
    return true
  end

  def check_columns

  end

  def check_crosses

  end

end


solver = Bingo.new("./example_input.txt")
# puts "Part1: #{solver.solve("./input.txt")}"
# solver = BinDiagV2.new()
# puts "Part2: #{solver.solve("./input.txt")}"

# describe BinDiag do
#   it "should return 198 for part one" do
#     object_under_test = BinDiag.new()
#     assert_equal 198, object_under_test.solve("./example_input.txt")
#   end

#   it "should return 230 for part two" do
#     object_under_test = BinDiagV2.new()
#     assert_equal 230, object_under_test.solve("./example_input.txt")
#   end
# end