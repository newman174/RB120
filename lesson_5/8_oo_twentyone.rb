=begin

Twenty-one is a card game consisting of a dealer and a player, where the
participants try to get as close to 21 as possible without going over.

Here is an overview of the game:
- Both participants are initially dealt 2 cards from a 52-card deck.
- The player takes the first turn, and can "hit" or "stay".
- If the player busts, he loses. If he stays, it's the dealer's turn.
- The dealer must hit until his cards add up until at least 17.
- If he busts, the player wins. If both player and dealer stay, then the highest
  total wins.
- If both totals are equal, then it's a tie, and nobody wins.

Nouns: card, player, dealer, participant, deck, game, total
Verbs: deal, hit, stay, busts

Player
- hit
- stay
- busted?
- total

Dealer
- hit
- stay
- busted?
- total
- deal (should this be here or in Deck?)

Participant

Deck
- deal (should this be here or in Dealer?)

Card
Game
- start

=end

require 'pry'

module Prompt
  PROMPT_SYMBOL = ">> "
  def prompt(msg, blank: false, blank_lines: 0)
    prefix = blank ? '   ' : PROMPT_SYMBOL
    puts "#{prefix}#{msg}"
    blank_lines.times { puts }
  end
end

class Participant
  include Prompt

  attr_accessor :name, :hand

  def initialize(name)
    self.name = name
    self.hand = []
  end

  def hit(deck)
    hand << deck.cards.pop
  end

  def deal(deck)
    2.times { hit(deck) }
  end

  def total
    total = 0
    hand.each { |card| total += card.value }
    total
  end

  def discreet_total
    if hand.all? { |card| card.visible }
      total
    else
      '??'
    end
  end

  def display_total
    prompt "#{name}'s current total: #{total}", blank_lines: 1
  end

  def display_hand
    prompt "#{name} has #{discreet_total} points:"
    hand.each do |card|
      prompt card, blank: true
    end
    puts
  end

  def to_s
    name
  end

  def reset_hand
    self.hand = []
  end
end

class Player < Participant
  def hit?
    choice = nil
    loop do
      prompt "Would you like to hit or stay? Enter h or s."
      choice = gets.chomp.downcase
      break if ['h', 's'].include?(choice)
      prompt "Sorry that's not a valid choice. Please enter h or s."
    end
    choice == 'h'
  end
end

class Dealer < Participant
  def initialize(name)
    super
  end

  def deal(deck)
    super
    hand.last.visible = false
  end

  def hit?
    total < Game::DEALER_STAY_AT
  end
end

class Deck
  CARD_NAMES = %w(A 2 3 4 5 6 7 8 9 10 J Q K)
  SUITS = %w(♤ ♡ ♧ ♢)

  attr_accessor :cards

  def initialize
    self.cards = []
    CARD_NAMES.each do |name|
      SUITS.each do |suit|
        cards << Card.new(name, suit)
      end
    end
    cards.shuffle!
  end
end

class Card
  VALUES = { 'A'   =>  1,
             '2'     =>  2,
             '3'     =>  3,
             '4'     =>  4,
             '5'     =>  5,
             '6'     =>  6,
             '7'     =>  7,
             '8'     =>  8,
             '9'     =>  9,
             '10'    => 10,
             'J'  => 10,
             'Q' => 10,
             'K'  => 10 }

  attr_accessor :name, :value, :suit, :visible

  def initialize(name, suit)
    # what are the states of a card?
    self.name = name
    self.suit = suit
    self.value = VALUES[name]
    self.visible = true
  end

  def to_s
    if visible
      "[#{format("%2s", name)} #{suit} ]"
    else
      "[  ?  ]"
    end
  end

  def draw
  end
end

module GameDisplay
  
  class Display
    attr_accessor :frames

    def initialize
      self.frames = []
    end

    def show
      frames.each(&:print)
    end

  class Frame
    attr_accessor :lines

    def initialize
      self.lines = []
    end

    def width
      lines.map { |line| line.length }.max
    end

    def print

    end
  end
end

class Game
  include Prompt

  MAX_POINTS = 21
  DEALER_STAY_AT = 17

  attr_accessor :deck, :player, :dealer, :participants, :winner

  def initialize
    self.deck = Deck.new
    self.player = Player.new("Mike")
    self.dealer = Dealer.new("CPU Dealer")
    self.participants = [player, dealer]
  end

  def deal_cards
    participants.each do |part|
      part.deal(deck)
    end
  end

  def display_cards
    participants.each { |part| part.display_hand }
  end

  def busted?(participant)
    participant.total > MAX_POINTS
  end

  def participant_turn(participant)
    loop do
      clear
      prompt "#{participant}'s Turn", blank_lines: 1
      display_cards
      if participant.hit?
        participant.hit(deck)
        clear
        prompt "#{participant} hits and is dealt a #{participant.hand.last}"
        display_cards

        if busted?(participant)
          prompt "#{participant} busted!", blank_lines: 1
          break
        end
      else
        prompt "#{participant} stays.", blank_lines: 1
        break
      end
    end
  end

  def player_turn
    participant_turn(player)
  end

  def dealer_turn
    participant_turn(dealer)
  end

  def determine_winner
    if busted?(player)
      dealer
    elsif busted?(dealer)
      player
    elsif player.total == dealer.total
      :tie
    else
      player.total > dealer.total ? player : dealer
    end
  end

  def show_result
    participants.each { |part| part.display_total }
  
    winner = determine_winner
    if winner == :tie
      prompt "It's a tie!"
    else
      prompt "#{winner} is the winner!"
    end
  end

  def take_turns
    player_turn
    enter_to_continue
    return if busted?(player)
    dealer_turn
  end

  def display_welcome_screen
    clear
    prompt "Welcome to Twenty One!\n"
    prompt "[RULES]\n"
    enter_to_continue
    clear
  end

  def enter_to_continue
    prompt "Press enter to continue."
    gets
  end

  def reset
    self.deck = Deck.new
    participants.each { |part| part.reset_hand}
    prompt "New Game!"
    enter_to_continue
    clear
  end

  def play_again?
    answer = nil
    loop do
      prompt "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      prompt "Sorry, must be y or n"
    end

    answer == 'y'
  end

  def display_goodbye_message
    prompt "Thanks for playing Twenty One. Goodbye!"
  end

  def clear
    system 'clear'
  end

  def play
    display_welcome_screen
    loop do
      deal_cards
      display_cards
      take_turns
      show_result
      break unless play_again?
      reset
    end
    clear
    display_goodbye_message
  end
end

game = Game.new
game.play
# binding.pry
