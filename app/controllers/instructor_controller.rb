class InstructorController < ApplicationController

  get '/instructors' do
    erb :'/instructors/index'
  end


end
