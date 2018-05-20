class Student < ActiveRecord::Base
  has_many :flights
  has_many :instructors, through: :flights
end
