# My Solution

class GuessingGame
  MAX_ATTEMPTS = 7
  NUM_RANGE = (1..100)

  def display_remaining_guesses
    puts "You have #{@remaining_guesses} guesses remaining."
  end

  def too_low_message
    "Your guess is too low."
  end

  def too_high_message
    "Your guess is too high."
  end

  def valid_guess?(guess)
    in_range?(guess) && num?(guess)
  end

  def num?(str)
    str.to_i.to_s == str
  end

  def in_range?(num)
    NUM_RANGE.include?(num.to_i)
  end

  def guess_prompt
    "Enter a number between #{NUM_RANGE.min} to #{NUM_RANGE.max}:"
  end

  def player_guess
    puts guess_prompt

    guess = nil
     loop do
       guess = gets.chomp
       if valid_guess?(guess)
        @guess = guess.to_i
        @remaining_guesses -= 1
        break
       else
        puts "Invalid guess. #{guess_prompt}"
       end
     end
  end

  def correct_guess?
    @guess == @target_num
  end

  def react_to_guess
    case @guess <=> @target_num
    when 1
      puts "Your guess is too high."
    when 0
      puts "That's the number!"
    when -1
      puts "Your guess is too low."
    end
    puts
  end

  def reset
    @remaining_guesses = MAX_ATTEMPTS
    @target_num = NUM_RANGE.to_a.sample
  end

  def play
    reset
    loop do
      display_remaining_guesses
      player_guess
      react_to_guess
      break if correct_guess? || @remaining_guesses == 0
    end
    puts "You won!" if correct_guess?
  end
end

game = GuessingGame.new
game.play