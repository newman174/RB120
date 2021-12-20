# namespacing.rb

module Mammal
  class Dog
    def speak(sound)
      p "#{sound}"
    end
  end

  class Cat
    def say_name(name)
      p "#{name}"
    end
  end

  def self.some_out_of_place_method(num)
    num ** 2
  end
end

lily = Mammal::Dog.new
hamachi = Mammal::Cat.new
lily.speak('Arf!')
hamachi.say_name('Hamachi, neko ichiban desu')

value = Mammal.some_out_of_place_method(4) # preferred
p value
value = Mammal::some_out_of_place_method(5) # alternative
p value