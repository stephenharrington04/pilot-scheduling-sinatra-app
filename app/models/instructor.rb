class Instructor < ActiveRecord::Base
  has_many :flights
  has_many :students, through: :flights
  has_secure_password
end
