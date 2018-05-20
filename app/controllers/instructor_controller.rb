class InstructorController < ApplicationController

  get '/instructors' do
    @instructors = Instructor.all
    erb :'/instructors/index'
  end

  get '/instructors/signup' do
    redirect "/instructors/index" if logged_in?
    erb :'/instructors/create_instructor'
  end

  post '/instructors' do
    redirect "/instructors/signup" if params.has_value?("")
    redirect "/instructors/signup" if params[:admin_password] != "instructor password"
    redirect "/instructors/signup" if Instructor.find_by(email: params[:instructor][:email])
    @instructor = Instructor.create(params[:instructor])
    session[:instructor_id] = @instructor.id
    binding.pry
    redirect "/instructors/:slug"
  end

  get '/instructors/login' do
    redirect "/instructors/index" if logged_in?
    erb :'/instructors/login'
  end

  post '/instructors/login' do

    redirect "/instructors/:slug"
  end

  get '/instructors/:slug' do

    erb :'/instructors/show'
  end



end
