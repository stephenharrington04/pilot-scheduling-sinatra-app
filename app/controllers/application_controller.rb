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
   redirect "/"
 end

 helpers do
   def instructor_logged_in?
    !!session[:instructor_id]
   end

   def student_logged_in?
     !!session[:student_id]
   end

   def instructor_go_log_in
      redirect "/" if !instructor_logged_in?
   end

   def student_go_log_in
      redirect "/" if !student_logged_in?
   end

   def current_instructor
      Instructor.find(session[:instructor_id])
   end

   def current_student
      Student.find(session[:student_id])
   end
  end
end
