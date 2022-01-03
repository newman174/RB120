=begin

Rock, Paper, Scissors is a two-player game where each player chooses
one of three possible moves: rock, paper, or scissors. The chosen moves
will then be compared to see who wins, according to the following rules:

- rock beats scissors
- scissors beats paper
- paper beats rock

If the players chose the same move, then it's a tie.

Nouns: player, move, rule
Verbs: choose, compare

Player
  - choose
Move
Rule

  - compare

# RPS
Display match welcome msg
Get player name
Play first round
Unless game over, ask if next round
Play next round
Unless game over, ask if next round
If game over
  show score
  declare winner
Unless play again:
  display goodbye message

=end

class Player
  @@members = []

  def self.members
    @@members
  end

  attr_accessor :move, :name, :wins

  def initialize
    set_name
    @@members.push(self)
    self.wins = 0
  end

  def record_win
    self.wins = self.wins + 1
  end

  def to_s
    self.name
  end
end

class Human < Player
  def set_name
    n = ""
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, must enter a value."
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts "Please choose rock, paper, or scissors:"
      choice = gets.chomp
      break if Move::VALUES.include?(choice)
      puts "Sorry, invalid choice."
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

class Move
  VALUES = ['rock', 'paper', 'scissors']

  def initialize(value)
    @value = value
  end

  def scissors?
    @value == 'scissors'
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def >(other_move)
    (rock? && other_move.scissors?) ||
      (paper? && other_move.rock?) ||
      (scissors? && other_move.paper?)
  end

  def <(other_move)
    (rock? && other_move.paper?) ||
      (paper? && other_move.scissors?) ||
      (scissors? && other_move.rock?)
  end

  def to_s
    @value
  end
end

class RPSMatch
  attr_accessor :rounds, :players, :human, :computer

  def initialize
    self.human = Human.new
    self.computer = Computer.new
    self.players = [human, computer]
    self.rounds = []
  end

  def play_again?(msg = "Would you like to play again?")
    answer = nil
    loop do
      puts "#{msg} (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include? answer.downcase
      puts "Sorry, must be y or n."
    end

    return false if answer.downcase == 'n'
    return true if answer.downcase == 'y'
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors!"
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors. Goodbye!"
  end

  def display_scores
    players.each { |plyr| puts "#{plyr} | #{plyr.wins}" }
  end

  def declare_winner
    winner = players.max_by(&:wins)
    puts "#{winner} is the winner!"
  end

  def play(points_to_win = 3)
    display_welcome_message
    loop do
      current_round = RPSRound.new(human, computer, rounds.size + 1)
      current_round.play
      rounds.push(current_round)
      break if players.any? { |plyr| plyr.wins >= points_to_win }
      display_scores
    end
    display_scores
    declare_winner
  end
end

class RPSRound
  attr_accessor :human, :computer, :human_move, :computer_move, :round_num

  def initialize(human, computer, round_num)
    self.human = human
    self.computer = computer
    self.round_num = round_num
  end

  def display_moves
    puts "#{human.name} chose: #{human.move}"
    puts "#{computer.name} chose: #{computer.move}"
  end

  def winner
    if @winner.nil?
      @winner = if human.move > computer.move
                      human
                    elsif computer.move > human.move
                      computer
                    else
                      :tie
                    end
    end
    @winner
  end

  def display_winner
    case winner
    when :tie then puts "It's a tie!"
    when nil then puts "Unknown"
    else
      puts "#{winner.name} won!"
    end
  end

  def display_new_round_message
    puts "Round #{round_num}: Start!"
  end

  def record_moves
    self.human_move = human.move
    self.computer_move = computer.move
  end

  def record_win
    winner.record_win unless winner == :tie
  end

  def players
    [human, computer]
  end

  def play
    display_new_round_message
    human.choose
    computer.choose
    record_moves
    record_win
    display_winner
  end
end

RPSMatch.new.play
