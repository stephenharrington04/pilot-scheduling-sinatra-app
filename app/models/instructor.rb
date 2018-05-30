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

  def instructor_days_req
    counter = 0
    students.each do |student|
      case student.course_type
      when "IAC"
        counter += 3
      when "PIQ"
        counter += 2
      when "ACQ"
        counter += 2
      when "PTX"
        counter += 2
      when "T3"
        counter += 1
      when "None"
        counter += 0
      end
    end
    counter
  end
end
