# my_car.rb

# frozen_string_literal: true

module Towable
  attr_accessor :towing_cap, :currently_towing

  def initialize(year, color, make, model, miles, gallons, towing_cap)
    super(year, color, make, model, miles, gallons)
    self.currently_towing = 0
    self.towing_cap = towing_cap
  end

  def info
    super
    puts "Towing Capacity: #{towing_cap} lbs"
  end

  def can_tow?(pounds)
    pounds < towing_cap ? true : false
  end

  def tow(weight)
    self.currently_towing += weight
  end
end

class Vehicle
  attr_accessor :year, :color, :make, :model, :speed, :on, :miles, :gallons
  @@number_of_vehicles = 0

  def self.number_of_vehicles
    plurals = @@number_of_vehicles == 1 ? ['is', ''] : ['are', 's']
    puts "There #{plurals[0]} #{@@number_of_vehicles} vehicle#{plurals[1]}."
  end

  def initialize(year, color, make, model, miles, gallons)
    @year = year
    @color = color
    @make = make
    @model = model
    @speed = 0
    @on = false 
    @miles = miles
    @gallons = gallons
    @@number_of_vehicles += 1
  end

  def info
    puts "Color: #{@color}"
    puts "Year: #{@year}"
    puts "Make: #{@make}"
    puts "Model: #{@model}"
    puts "Speed: #{@speed}"
    puts "On?: #{@on}"
    puts "Miles: #{@miles}"
    puts "Gallons: #{@gallons}"
  end

  def accelerate(addl_speed)
    @speed += addl_speed
    puts "You push the gas and accelerate #{addl_speed} mph."
  end

  def brake(less_speed)
    @speed -= less_speed
    puts "You push the brake and decelerate #{less_speed} mph."
  end

  def current_speed
    puts "You are now going #{@speed} mph."
  end

  def toggle_ignition
    @on = !@on
    case @on
    when true
      puts 'You turn the car on.'
    when false
      @speed = 0
      puts 'You turn the car off.'
    end
  end

  def spray_paint(color)
    self.color = color
    puts "Your new #{color} paint job looks great!"
  end

  def self.mpg(miles, gallons)
    mpg = miles.fdiv(gallons).round(1)
    puts "#{mpg} MPG"
  end

  def mpg
    MyCar.mpg(miles, gallons)
  end

  def to_s
    "#{year} #{make} #{model} in #{color}"
  end

  def age
    years_old
  end

  private

  def years_old
    # ((Time.new - Time.new(year)) / 60 / 60 / 24 / 365).round(2)
    Time.now.year - self.year.to_i
  end
end

class MyTruck < Vehicle
  include Towable
  TOWING = true
  NUMBER_OF_DOORS = 2
  attr_accessor :towing_cap

  def to_s
    super + "; Towing Capacity: #{towing_cap} lbs"
  end
end

class MyCar < Vehicle
  TOWING = false
  NUMBER_OF_DOORS = 4
end

mazda = MyCar.new(2021, 'White', 'Mazda', 'CX-5', 104, 5)

mazda.info
puts
mazda.color = 'Soul Red'
mazda.info

puts
mazda.toggle_ignition
mazda.current_speed

mazda.accelerate(10)
mazda.current_speed
mazda.accelerate(5)
mazda.current_speed
mazda.brake(10)
mazda.current_speed

mazda.toggle_ignition
mazda.current_speed
puts "on = #{mazda.on}"

puts mazda.color
mazda.spray_paint('blue')
puts mazda.color
puts mazda.year
MyCar.mpg(100.4, 5)
# mazda = MyCar.new(2021, 'White', 'Mazda', 'CX-5', 104, 5)
# mazda.info
# puts
# mazda.mpg
# puts "My car is a #{mazda}"

# Vehicle.number_of_vehicles
# puts
# mazda.info
# puts
# puts mazda
# puts

# Vehicle.number_of_vehicles
# puts


dad_truck = MyTruck.new(2019, 'White', 'Ford', 'F-150', 104, 7, 2000)
dad_truck.accelerate(7)
dad_truck.info
puts
puts dad_truck
# puts MyTruck.ancestors
puts dad_truck.can_tow?(21000)
# puts mazda.can_tow?(21000)

# puts
# puts MyTruck.ancestors
# puts
# puts MyCar.ancestors
# puts
# puts Vehicle.ancestors
# puts
# puts Towable.ancestors
# puts

p mazda.age
p dad_truck.age