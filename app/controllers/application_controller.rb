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

    def current_instructor
      Instructor.find(session[:instructor_id])
    end

    def current_student
      Student.find(session[:student_id])
    end

    def course_types
      ["IAC", "ACQ", "PIQ", "PTX", "T3"]
    end
  end
end
