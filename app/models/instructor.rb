class Instructor < ActiveRecord::Base
  has_secure_password

  has_many :flights
  has_many :students, through: :flights
end
