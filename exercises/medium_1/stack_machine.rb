# My Solution

require 'set'

class MinilangError < StandardError; end
class BadTokenError < MinilangError; end
class EmptyStackError < MinilangError; end

class Minilang
  ACTIONS = Set.new %w[PUSH ADD SUB MULT DIV MOD POP PRINT]

  attr_accessor :stack, :register

  def initialize(commands)
    @stack = []
    @register = 0
    @command_list = commands.split
  end

  def number?(str)
    str =~ /\A[-+]?\d+\z/
  end

  def eval
    @command_list.each { |cmd| eval_token(cmd) }
  rescue MinilangError => error
    puts error.message
  end
  
  private
  
  def eval_token(cmd)
    if ACTIONS.include?(cmd)
      send(cmd.downcase)
    elsif number?(cmd)
      @register = cmd.to_i
    else
      raise BadTokenError, "Invalid token: #{cmd}"
    end
  end

  def add
    @register += @stack.pop
  end

  def div
    @register /= @stack.pop
  end

  def mult
    @register *= @stack.pop
  end

  def mod
    @register %= @stack.pop
  end

  def sub
    @register -= @stack.pop
  end

  def push
    @stack.push(@register)
  end

  def pop
    raise EmptyStackError, "Empty stack!" if @stack.empty?
    @register = @stack.pop
  end

  def print
    puts @register
  end
end

Minilang.new('PRINT').eval
# 0

Minilang.new('5 PUSH 3 MULT PRINT').eval
# # 15

Minilang.new('5 PRINT PUSH 3 PRINT ADD PRINT').eval
# # 5
# # 3
# # 8

Minilang.new('5 PUSH 10 PRINT POP PRINT').eval
# # 10
# # 5

Minilang.new('5 PUSH POP POP PRINT').eval
# # Empty stack!

Minilang.new('3 PUSH PUSH 7 DIV MULT PRINT ').eval
# # 6

Minilang.new('4 PUSH PUSH 7 MOD MULT PRINT ').eval
# # 12

Minilang.new('-3 PUSH 5 XSUB PRINT').eval
# # Invalid token: XSUB

Minilang.new('-3 PUSH 5 SUB PRINT').eval
# # 8

Minilang.new('6 PUSH').eval
# (nothing printed; no PRINT commands)