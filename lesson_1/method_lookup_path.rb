# method_lookup_path.rb

module Walkable
  def walk
    "Eyy I'm walking here."
  end
end

module Swimmable
  def swim
    "I'm swimming."
  end
end

module Climbable
  def climb
    "I'm climbing."
  end
end

class Animal
  include Walkable

  def speak
    "I'm an animal, and I speak!"
  end
end

class GoodDog < Animal
  include Swimmable
  include Climbable
end

puts "--Animal method lookup---"
puts Animal.ancestors

fido = Animal.new
puts fido.speak
puts fido.walk
# puts fido.swim

puts "--GoodDog method lookup---"
puts GoodDog.ancestors