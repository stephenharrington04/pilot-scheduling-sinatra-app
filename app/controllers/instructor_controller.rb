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
    redirect "/instructors/:slug"
  end

  get '/instructors/login' do

    erb :'/instructors/login'
  end

  post '/instructors/login' do

    redirect "/instructors/:slug"
  end

  get '/instructors/:slug' do

    erb :'/instructors/show'
  end



end
