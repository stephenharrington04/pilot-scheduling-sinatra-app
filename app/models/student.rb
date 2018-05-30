class Student < ActiveRecord::Base
  has_many :flights
  has_many :instructors, through: :flights
  has_secure_password

  def slug
    name.downcase.scan(/\w|\d|[ ]/).join.gsub(" ", "-")
  end

  def self.find_by_slug(slug)
    Student.all.find{|student| student.slug == slug}
  end

  def student_flight_hours
    flights.map do |flight|
      flight.duration
    end.sum
  end

end
