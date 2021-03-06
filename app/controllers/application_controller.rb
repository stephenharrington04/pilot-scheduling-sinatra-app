require './config/environment'
require 'rack-flash'

class ApplicationController < Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "secret"
  end

  get '/' do
    erb :'/index'
  end

  get '/logout' do
   session.clear
   flash[:message] = "Successfully Logged Out!"
   redirect "/"
  end

  helpers do
    def instructor_logged_in?
      !!session[:instructor_id]
    end

    def student_logged_in?
      !!session[:student_id]
    end

    def ip_or_stud_logged_in?
      instructor_logged_in? || student_logged_in?
    end

    def go_log_in
      flash[:message] = "You muse be logged in to view this page."
      redirect "/"
    end

    def current_instructor
      @current_ip ||= Instructor.find(session[:instructor_id]) if session[:instructor_id]
    end

    def current_student
      @current_stud ||= Student.find(session[:student_id]) if session[:student_id]
    end

    def syllabus_types
      ["IAC", "ACQ", "PIQ", "PTX", "T3"]
    end

    def msn_types
      ["Student Training", "Continuation Training", "Student Checkride", "PP Checkride"]
    end
  end
end
