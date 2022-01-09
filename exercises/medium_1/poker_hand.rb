# poker

# Given Code

# Include Card and Deck classes from the last two exercises.
class Card
  include Comparable
  attr_reader :rank, :suit

  VALUES = { 'Jack' => 11, 'Queen' => 12, 'King' => 13, 'Ace' => 14 }

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def to_s
    "#{rank} of #{suit}"
  end

  def value
    VALUES.fetch(rank, rank)
  end

  def <=>(other_card)
    value <=> other_card.value
  end
end

class Deck
  RANKS = ((2..10).to_a + %w(Jack Queen King Ace)).freeze
  SUITS = %w(Hearts Clubs Diamonds Spades).freeze

  def initialize
    reset
  end

  def draw
    reset if @deck.empty?
    @deck.pop
  end

  private

  def reset
    @deck = RANKS.product(SUITS).map do |rank, suit|
      Card.new(rank, suit)
    end

    @deck.shuffle!
  end
end

class PokerHand
  HAND_SIZE = 5

  attr_reader :cards

  def initialize(deck)
    @cards = []
    if deck.class == Deck
      HAND_SIZE.times { @cards << deck.draw }
    else
      @cards = deck
    end
  end

  def print
    puts cards
  end

  def evaluate
    case
    when royal_flush?     then 'Royal flush'
    when straight_flush?  then 'Straight flush'
    when four_of_a_kind?  then 'Four of a kind'
    when full_house?      then 'Full house'
    when flush?           then 'Flush'
    when straight?        then 'Straight'
    when three_of_a_kind? then 'Three of a kind'
    when two_pair?        then 'Two pair'
    when pair?            then 'Pair'
    else                       'High card'
    end
  end

  # private

  def ranks
    cards.map { |card| card.value }
  end

  def suits
    cards.map { |card| card.suit }
  end

  def royal_flush?
    straight_flush? && cards.max.value == 13
  end

  def straight_flush?
    straight? && flush?
  end

  def four_of_a_kind?
    enough_sets?(ranks, set_size: 4, qty_needed: 1) 
  end
  
  def full_house?
    enough_sets?(ranks, set_size: 3, qty_needed: 1) &&
    enough_sets?(ranks, set_size: 2, qty_needed: 1)
  end
  
  def flush?
    enough_sets?(suits, set_size: 5, qty_needed: 1)
  end
  
  def straight?
    (0..ranks.size - 2).each do |i|
      return false unless ranks.sort[i] == ranks.sort[i + 1] - 1
    end
    true
  end
  
  def three_of_a_kind?
    enough_sets?(ranks, set_size: 3, qty_needed: 1) 
  end

  def two_pair?
    enough_sets?(ranks, set_size: 2, qty_needed: 2)
  end

  def pair?
    #  ranks.uniq != ranks
    enough_sets?(ranks, set_size: 2, qty_needed: 1)
  end

  def enough_sets?(source, set_size:, qty_needed:)
    counts = {}
    source.uniq.each do |rnk|
      counts[rnk] = source.count(rnk)
    end
    counts.values.count { |qty| qty == set_size } == qty_needed
  end
end

# deck = Deck.new
# hand = PokerHand.new(deck)
hand = PokerHand.new([
  Card.new(2, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(9, 'Spades'),
  Card.new(5, 'Diamonds')
])
puts hand.two_pair?

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(6, 'Diamonds')
])
puts hand.three_of_a_kind?

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(5, 'Diamonds')
])
puts hand.full_house?

hand = PokerHand.new([
  Card.new('Jack', 'Hearts'),
  Card.new('King', 'Clubs'),
  Card.new('Queen', 'Diamonds'),
  Card.new('Ace', 'Diamonds'),
  Card.new(10, 'Spades')
])
puts hand.straight?