# student.rb

class Student
  attr_accessor :name

  def initialize(n, g)
    self.name = n
    self.grade = g
  end

  def better_grade_than?(other_student)
    grade > other_student.grade
  end

  protected

  def grade
    @grade
  end

  def grade=(g)
    @grade = g
  end
end

bob = Student.new("Bob", 95)
joe = Student.new("Joe", 84)

p bob.name
# p bob.grade
p joe.name
puts "Well done!" if bob.better_grade_than?(joe)
p joe.grade