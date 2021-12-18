class GoodDog
  DOG_YEARS = 7
  @@number_of_dogs = 0

  attr_accessor :name, :height, :weight, :age

  def initialize(n, h, w, a)
    self.name = n
    self.height = h
    self.weight = w
    self.age = a * DOG_YEARS
    @@number_of_dogs += 1
  end

  def to_s
    "This dog's name is #{name} and it is #{age} in dog years."
  end

  def self.total_number_of_dogs
    @@number_of_dogs
  end

  def speak
    "#{self.name} says Arf!"
  end

  def change_info(n, h, w)
    self.name = n
    self.height = h
    self.weight = w
  end

  def info
    "#{self.name} weighs #{self.weight} and is #{self.height} tall."
  end

  def self.what_am_i
    "I'm a GoodDog class!"
  end

  def what_is_self
    self
  end
end

# puts GoodDog.total_number_of_dogs

sparky = GoodDog.new('Sparky', '12 inches', '10 lbs', 4)
p sparky.what_is_self
# puts sparky.info
# spartacus = GoodDog.new('Spartacus', '24 inches', '45 lbs', 3)
# puts spartacus.info

# sparky.change_info('Spartacus', '24 inches', '45 lbs')
# puts sparky.info

# puts sparky.speak
# puts sparky.name
# sparky.name = 'Spartacus'
# puts sparky.name
# fido = GoodDog.new('Fido')
# puts fido.speak

# puts GoodDog.what_am_i

# puts GoodDog.total_number_of_dogs
# puts sparky.age
# puts spartacus.age
# puts spartacus
# p spartacus
