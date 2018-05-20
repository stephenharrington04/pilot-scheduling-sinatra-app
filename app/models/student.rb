class Student < ActiveRecord::Base
  has_secure_password

  has_many :flights
  has_many :instructors, through: :flights
end
