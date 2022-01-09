class CircularQueue
  attr_accessor :buffer, :newest, :oldest, :size

  def initialize(size)
    self.size = size
    self.buffer = Array.new(size)
    self.oldest = 0
    self.newest = 0
  end


  def increment_read_ptr
    last_index = size - 1
    if read_ptr >= last_index
      self.read_ptr = 0
    else
      self.read_ptr = read_ptr + 1
    end
    nil
  end

  def increment_write_ptr
    last_index = size - 1
    if write_ptr >= last_index
      self.write_ptr = 0
      increment_read_ptr
    else
      self.write_ptr = write_ptr + 1
    end
    nil
  end

  def enqueue(elem)
    self.newest += 1
    self.buffer[newest] = elem
    increment_write_ptr
    self.buffer
  end

  def dequeue
    output = buffer[read_ptr]
    buffer[read_ptr] = nil
    increment_read_ptr
    output
  end
end

queue = CircularQueue.new(3)
queue.enqueue(1)
queue.enqueue(2)
puts "dequeue = #{queue.dequeue}"

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