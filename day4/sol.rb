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
      @cards.each do |card| # mark all the cards
        card.mark(called_number)
      end

      @cards.map do |card| # return the math if one is a winner
        return card.calculate_win(called_number) if card.winner?
      end
    end
  end

  private

end

class BingoV2 < Bingo
  def solve
    @called_numbers.each do |called_number|
      @cards.each do |card|
        card.mark(called_number)
      end

      @cards.each do |card|
        if card.winner?
          if @cards.size > 1
            remove_winner(card) if card.winner?
          else
            return @cards.first.calculate_win(called_number)
          end
        end
      end
    end

  end

  def remove_winner(card)
    @cards.delete(card)
  end
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
    check_rows || check_columns
  end

  def calculate_win(winning_number)
    @card
      .flatten # make our 2d array a flat array for simplicity
      .select {|num| !num.include?("M")}  # only consider numbers that are not marked
      .map(&:to_i) # convert them from labels to integers
      .sum * winning_number.to_i #array.sum multiplied by the winning_number
  end

  private

  def check_sequence(seq)
    seq.each do |number|
      return false unless number.include?("M") # return false as soon as an unmarked space is found
    end
    return true
  end

  def check_rows
    @card.each do |row|
      return true if check_sequence(row)
    end
    return false
  end

  def check_columns # build the column sequence
    (0..@card.length-1).each do |index| # for each column
      column = @card.map do |row| # for each row
        row[index] # grab the space from each row in a specific column
      end
      return true if check_sequence(column)
    end
    return false
  end

end

solver = Bingo.new("./input.txt")
puts "Part1: #{solver.solve}"
solver = BingoV2.new("./input.txt")
puts "Part2: #{solver.solve}"

describe Bingo do
  it "should return 4512 for part one example" do
    object_under_test = Bingo.new("./example_input.txt")
    assert_equal 4512, object_under_test.solve
  end

  it "should return 1924 for part two" do
    object_under_test = BingoV2.new("./example_input.txt")
    assert_equal 1924, object_under_test.solve
  end
end