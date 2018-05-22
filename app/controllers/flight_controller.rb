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

  get '/flights/:id/edit' do
    @flight = Flight.find(params[:id])
    erb :'/flights/edit'
  end

  patch '/flights/:id' do
    flight = Flight.find_by(params[:id])
    flight.update(params[:flight])
    flight.save
    redirect "/flights/#{flight.id}"
  end

  get '/flights/:id/delete' do
    @flight = Flight.find(params[:id])
    erb :'flights/delete'
  end

  delete '/flights/:id/delete' do
    @flight = Flight.find(params[:id])
    if current_instructor.authenticate(params[:instructor_password])
      @flight.delete
      flash[:message] = "Successfully Deleted Flight!"
      redirect "/flights"
    end
    flash[:message] = "Incorrect Password.  Please Try Again."
    redirect "/flights/#{@flight.id}/delete"
  end



end
