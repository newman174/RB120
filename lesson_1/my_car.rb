# my_car.rb

class MyCar
  attr_accessor :year, :color, :make, :model, :speed, :on, :miles, :gallons
  # attr_accessor :color
  # attr_reader :year, :on

  def initialize(year, color, make, model, miles, gallons)
    @year = year
    @color = color
    @make = make
    @model = model
    @speed = 0
    @on = false
    @miles = miles
    @gallons = gallons
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
      puts "You turn the car on."
    when false
      @speed = 0
      puts "You turn the car off."
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
end

# mazda = MyCar.new(2021, 'White', 'Mazda', 'CX-5', 104, 5)
# mazda.info
# puts
# mazda.color = 'Soul Red'
# mazda.info

# puts
# mazda.toggle_ignition
# mazda.current_speed

# mazda.accelerate(10)
# mazda.current_speed
# mazda.accelerate(5)
# mazda.current_speed
# mazda.brake(10)
# mazda.current_speed

# mazda.toggle_ignition
# mazda.current_speed
# puts "on = #{mazda.on}"

# puts mazda.color
# mazda.spray_paint('blue')
# puts mazda.color
# puts mazda.year
# MyCar.mpg(100.4, 5)
mazda = MyCar.new(2021, 'White', 'Mazda', 'CX-5', 104, 5)
# mazda.info
# mazda.mpg
puts "My car is a #{mazda}"