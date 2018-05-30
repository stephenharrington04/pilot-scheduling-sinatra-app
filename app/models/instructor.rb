class Instructor < ActiveRecord::Base
  has_many :flights
  has_many :students, through: :flights
  has_secure_password

  def slug
    name.downcase.scan(/\w|\d|[ ]/).join.gsub(" ", "-")
  end

  def self.find_by_slug(slug)
    Instructor.all.find{|instructor| instructor.slug == slug}
  end

  def instructor_flight_hours
    flights.map do |flight|
      flight.duration
    end.sum
  end
end
