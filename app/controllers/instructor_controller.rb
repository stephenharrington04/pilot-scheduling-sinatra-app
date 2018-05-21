class InstructorController < ApplicationController

  get '/instructors' do
    redirect "/" if !logged_in?
    @instructors = Instructor.all
    erb :'/instructors/index'
  end

  get '/instructors/signup' do
    redirect "/instructors" if logged_in?
    erb :'/instructors/create_instructor'
  end

  #hard coded the admin_password for now.  May change to be dynamic later.

  post '/instructors' do
    redirect "/instructors/signup" if Instructor.find_by(email: params[:instructor][:email])
    redirect "/instructors/signup" if params.has_value?("")
    redirect "/instructors/signup" if params[:admin_password] != "instructor password"
    instructor = Instructor.create(params[:instructor])
    session[:instructor_id] = instructor.id
    redirect "/instructors/#{instructor.slug}"
  end

  get '/instructors/login' do
    redirect "/instructors" if logged_in?
    erb :'/instructors/login'
  end

  post '/instructors/login' do
    instructor = Instructor.find_by(email: params[:email])
    if instructor && instructor.authenticate(params["password"])
      session[:instructor_id] = instructor.id
      redirect "/instructors/#{instructor.slug}"
    end
    redirect "/instructors/login"
  end

  get '/instructors/:slug' do
    redirect "/" if !logged_in?
    @instructor = Instructor.find_by_slug(params[:slug])
    erb :'/instructors/show'
  end

  get '/instructors/:slug/edit' do
    redirect "/" if !logged_in?
    @instructor = Instructor.find_by_slug(params[:slug])
    redirect "/instructors" if current_instructor != @instructor
    erb :'/instructors/edit'
  end

  patch '/instructors/:slug' do

  end

  delete '/instructors/:slug/delete' do
    redirect "/instructors" if current_instructor != Instructor.find_by_slug(params[:slug])
    current_instructor.delete
    session.clear
    redirect "/"
  end

end
