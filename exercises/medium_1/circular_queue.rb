# My Solution

class CircularQueue
  attr_accessor :write_ptr, :read_ptr, :size, :buffer

  def initialize(size)
    self.size = size
    self.buffer = Array.new(size)
    self.write_ptr = 0
    self.read_ptr = 0
    # p buffer
  end

  def enqueue(elem)
    # puts "write_ptr = #{write_ptr}"
    self.buffer[write_ptr] = elem
    p buffer
    if write_ptr >= size - 1
      self.write_ptr = 0
      # self.read_ptr += 1
      # puts "read_ptr = #{read_ptr}"
    else
      self.write_ptr = write_ptr + 1
    end
    # puts "write_ptr = #{write_ptr}"
    # puts
    nil
  end

  def dequeue
    # puts "read_ptr = #{read_ptr}"
    output = buffer[read_ptr]
    buffer[read_ptr] = nil
    if read_ptr >= size - 1
      self.read_ptr = 0
    else
      self.read_ptr = read_ptr + 1
    end
    # puts "read_ptr = #{read_ptr}"
    output
  end
end

queue = CircularQueue.new(3)
queue.enqueue('1')
queue.enqueue('2')
# puts "dequeue = #{queue.dequeue}"
p queue.buffer
# puts

queue.enqueue('3')

# puts "write_ptr = #{queue.write_ptr}"
# puts "read_ptr = #{queue.read_ptr}"
queue.enqueue('4')
# puts "dequeue = #{queue.dequeue}"
p queue.buffer
# puts
queue.enqueue('5')
queue.enqueue('6')
queue.enqueue('7')
# puts "dequeue = #{queue.dequeue}"
p queue.buffer
# puts
nil