# good_dog2.rb

class Animal
  attr_accessor :name

  def initialize(name)
    self.name = name
  end

  def speak
    "Hello!"
  end
end

class GoodDog < Animal
  def initialize()
    super
    @color = color
  end
end

# class Cat < Animal
# end

# sparky = GoodDog.new("Sparky")
# hamachi = Cat.new("Hamachi")
# puts sparky.speak
# puts hamachi.speak

bruno = GoodDog.new("brown")