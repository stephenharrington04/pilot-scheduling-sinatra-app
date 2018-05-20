require './config/environment'

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
   def logged_in?
    !!session[:instructor_id] || !!session[:student_id]
   end

   def go_log_in
      redirect "/login" if !logged_in?
   end
  end
end
