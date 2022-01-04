=begin

1. Write a description of the problem and extract major nouns and verbs.
2. Make an initial guess at organizing the verbs into nouns and do a spike to explore the problem with temporary code.
3. Optional - when you have a better idea of the problem, model your thoughts into CRC cards.


Tic Tac Toe ('TTT') is a game where 2 players take turns marking a square from a 3x3 board. If at the end of any turn a player has selected 3 squares that form a straight line, then that player wins. If there are no remaining squares to select from, then the game ends in a tie.

Nounds:
  Players
  Square
  Board
  Turn
  Line

Verbs:
  Play
  Mark



# LS
Tic Tac Toe is a 2-player board game played on a 3x3 grid. Players take turns marking a square. The first player to mark 3 squares in a row wins.

Nouns: board, player, square, grid
Verbs: play, mark


Board
Square
Player
- mark
- play

=end

class Board
  def initialize
    # We need some way to model the 3x3 grid. Maybe "squares"?
    # What data structure should we use?
    # - array/hash of Square objects?
    # - array/hash of strings or integers?
  end
end

class Square
  def initialize
    # Maybe a "status" to keep track of this square's mark?
  end
end

class Player
  def initialize
    # Maybe a "marker" to keep track of this player's symbol (i.e. 'X' or 'O')
  end

  def mark

  end
end

class TTTGame
  def play
    display_welcome_message
    loop do
      display_board
      first_player_moves
      break if someone_won? || board_full?
      
      second_player_moves
      break if someone_won? || board_full?
    end
    display_result
    display_goodbye_message
  end
end

# we'll kickoff a game like this
game = TTTGame.new
game.play