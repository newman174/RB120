# My Solution

class CircularQueue
  attr_accessor :add_ptr, :take_ptr, :size, :buffer

  def initialize(size)
    self.size = size
    self.buffer = Array.new(size)
    self.add_ptr = 0
    self.take_ptr = 0
    # p buffer
  end

  def increment_take_ptr
    self.take_ptr = take_ptr + 1
    self.take_ptr = 0 if take_ptr >= size
    nil
  end

  def increment_add_ptr
    self.add_ptr = add_ptr + 1
    self.add_ptr = 0 if add_ptr >= size
    nil
  end

  def enqueue(elem)
    increment_take_ptr if add_ptr == take_ptr && !empty?
    self.buffer[add_ptr] = elem
    increment_add_ptr
    self.buffer
  end

  def dequeue
    output = buffer[take_ptr]
    buffer[take_ptr] = nil
    # increment_add_ptr if take_ptr == add_ptr
    increment_take_ptr
    output
  end

  def empty?
    buffer.all?(&:nil?)
  end
end

queue = CircularQueue.new(3)
queue.enqueue(1)
queue.enqueue(2)
puts "dequeue = #{queue.dequeue}. s/b == 1"

queue.enqueue(3)

queue.enqueue(4)
puts "dequeue = #{queue.dequeue}. s/b == 2"
queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts "dequeue = #{queue.dequeue} s/b == 5"
puts "dequeue = #{queue.dequeue} s/b == 6"
puts "dequeue = #{queue.dequeue} s/b == 7"
puts "dequeue = #{queue.dequeue} s/b == nil"
nil