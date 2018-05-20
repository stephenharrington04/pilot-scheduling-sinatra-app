class InstructorController < ApplicationController

  get '/instructors' do

    erb :'/index'
  end

  get '/instructors/signup' do

    erb :'/instructors/create_instructor'
  end

  post '/instructors/signup' do

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
