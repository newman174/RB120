require_relative 'game_display'

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
    hand.all?(&:visible) ? total : '??'
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
  def deal(deck)
    super
    hand.last.visible = false
  end

  def hit?
    total < Game::DEALER_STAY_AT
  end

  def reveal_cards
    hand.each(&:reveal)
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
  VALUES = {
    'A' =>  1,
    '2' =>  2,
    '3' =>  3,
    '4' =>  4,
    '5' =>  5,
    '6' =>  6,
    '7' =>  7,
    '8' =>  8,
    '9' =>  9,
    '10' => 10,
    'J' => 10,
    'Q' => 10,
    'K' => 10
  }

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

  def reveal
    self.visible = true
  end
end

class Game
  include Prompt

  RULES = <<-RULES
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
  RULES

  MAX_POINTS = 21
  DEALER_STAY_AT = 17

  attr_accessor :deck, :player, :dealer, :participants, :winner

  def initialize
    self.deck = Deck.new
    self.player = Player.new("Mike")
    self.dealer = Dealer.new("CPU Dealer")
    self.participants = [dealer, player]
  end

  def deal_cards
    participants.each do |part|
      part.deal(deck)
    end
  end

  def display_cards
    card_disp = GameDisplay::Display.new
    participants.each do |part|
      frame = GameDisplay::Frame.new
      frame.add_line(text: part.to_s, align: :center)
      frame.add_line
      part.hand.each do |card|
        frame.add_line(text: card.to_s)
      end
      frame.add_line
      frame.add_line(text: "Total: #{part.discreet_total}")
      card_disp.add_frame(frame)
    end
    card_disp.show
  end

  def busted?(participant)
    participant.total > MAX_POINTS
  end

  def participant_turn(participant)
    loop do
      clear
      display_cards
      prompt "#{participant}'s Turn", blank_lines: 1
      enter_to_continue if participant == dealer
      if participant.hit?
        participant.hit(deck)
        clear
        display_cards
        prompt "#{participant}'s Turn", blank_lines: 1
        prompt "Would you like to hit or stay? h/s"
        puts 'h'
        prompt "#{participant} hits and is dealt a #{participant.hand.last}"
        enter_to_continue

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
    dealer.reveal_cards
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
    participants.each(&:display_total)

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
    if busted?(player)
      dealer.reveal_cards
      display_cards
      return
    end
    dealer_turn
  end

  def refresh_screen
    display.show
  end

  def new_frame
    GameDisplay::Frame.new
  end

  def display_welcome_screen
    clear
    welcome_screen = GameDisplay::Display.new
    top_frame = new_frame
    welcome_screen.add_frame(top_frame)
    top_frame.add_line(text: "*** Welcome to Twenty One! ***", align: :center)
    top_frame.add_line
    RULES.lines.each { |rule| top_frame.add_line(text: rule.chomp) }
    welcome_screen.show
    puts
    enter_to_continue
    clear
  end

  def enter_to_continue
    prompt "Press enter to continue."
    gets
  end

  def reset
    self.deck = Deck.new
    participants.each(&:reset_hand)
    clear
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
      # display_cards
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
