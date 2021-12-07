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
  end

  def solve
    @called_numbers.each do |called_number|
      @cards.each do |card|
        card.mark(called_number)
      end

      @cards.map do |card|
        return card.calculate_win(called_number) if card.winner?
      end
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
    check_rows || check_columns #|| check_crosses
  end

  def calculate_win(winning_number)
    @card.flatten.select{ |num| !num.include?("M") }.map(&:to_i).sum * winning_number.to_i
  end

  private

  def check_rows
    @card.each do |row|
      return true if check_sequence(row)
    end
    return false
  end

  def check_sequence(seq)
    seq.each do |number|
      return false unless number.include?("M")
    end
    return true
  end

  def check_columns
    (0..@card.length-1).each do |index|
      column = @card.map do |row|
        row[index]
      end
      return true if check_sequence(column)
    end
    return false
  end

  # lmao didn't notice diagonals don't count FML
  # What kind of bingo IS THIS!?!
  def check_crosses
    range = (0..@card.length-1)

    top_left_to_bottom_right = []
    range.each do |row_index|
      range.each do |col_index|
        top_left_to_bottom_right << @card[row_index][col_index] if row_index == col_index
      end
    end
    return true if check_sequence(top_left_to_bottom_right)

    top_right_to_bottom_left = []
    range.each do |row_index|
      range.each do |col_index|
        top_right_to_bottom_left << @card[row_index][col_index] if row_index + col_index == range.max
      end
    end
    return true if check_sequence(top_right_to_bottom_left)
    
    return false
  end

end


# solver = Bingo.new("./example_input.txt")
# puts "Part1: #{solver.solve}"
# solver = BinDiagV2.new()
# puts "Part2: #{solver.solve("./input.txt")}"

describe Bingo do
  it "should return 4512 for part one example" do
    object_under_test = Bingo.new("./example_input.txt")
    assert_equal 4512, object_under_test.solve
  end

  # it "should return 230 for part two" do
  #   object_under_test = BinDiagV2.new()
  #   assert_equal 230, object_under_test.solve("./example_input.txt")
  # end
end