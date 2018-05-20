class Student < ActiveRecord::Base
  has_many :flights
  has_many :instructors, through: :flights
  has_secure_password
end
