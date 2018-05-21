class FlightController < ApplicationController

  get '/flights' do
    @flights = Flight.all
    erb :'/flights/index'
  end

  get '/flights/new' do
    erb :'flights/new'
  end

  post '/flights' do
    if params[:flight][:duration].to_f <= 0
      flash[:message] = "You must enter a duration greater than 0.0"
      redirect "/flights/new"
    end
    flight = Flight.create(params[:flight])
    flight.instructor = Instructor.find_by(name: params[:ip_name])
    flight.student = Student.find_by(name: params[:student_name])
    flight.save
    redirect "/flights/#{flight.id}"
  end

  get '/flights/:id' do
    @flight = Flight.find(params[:id])
    erb :'/flights/show'
  end

end
