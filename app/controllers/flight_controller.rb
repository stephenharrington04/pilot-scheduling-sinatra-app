class FlightController < ApplicationController

  get '/flights' do
    if instructor_logged_in? || student_logged_in?
      @flights = Flight.all
      erb :'/flights/index'
    else
      flash[:message] = "You muse be logged in to view this page."
      redirect "/"
    end
  end

  get '/flights/new' do
    if instructor_logged_in?
      erb :'flights/new'
    elsif student_logged_in?
      flash[:message] = "Sorry, Only Instructors May Create A New Flight."
      redirect "/flights"
    else
      flash[:message] = "You must be logged in to view this page."
      redirect "/"
    end
  end

  post '/flights' do
    if Flight.find_by(mission_number: params[:flight][:mission_number])
        flash[:message] = "A Flight Associated With This Mission Number Already Exists.  Please Try Again."
        redirect "/flights/new"
    elsif params[:flight][:duration].to_f <= 0
      flash[:message] = "You must enter a duration greater than 0.0"
      redirect "/flights/new"
    else
      flight = Flight.create(params[:flight])
      flight.instructor = Instructor.find_by(name: params[:ip_name])
      flight.student = Student.find_by(name: params[:student_name])
      flight.save
      redirect "/flights/#{flight.id}"
    end
  end

  get '/flights/:id' do
    if instructor_logged_in? || student_logged_in?
      @flight = Flight.find(params[:id])
      erb :'/flights/show'
    else
      flash[:message] = "You muse be logged in to view this page."
      redirect "/"
    end
  end

  get '/flights/:id/edit' do
    flight = Flight.find(params[:id])
    if student_logged_in?
      flash[:message] = "Sorry, Only Instructors May Edit A Flight."
      redirect "/flights/#{flight.id}"
    elsif !instructor_logged_in?
      redirect "/flights/#{flight.id}"
    elsif current_instructor != flight.instructor
      flash[:message] = "Sorry, Only #{flight.instructor.name} May Edit #{flight.callsign}."
      redirect "/flights/#{flight.id}"
    else
      @flight = flight
      erb :'/flights/edit'
    end
  end

# STILL HAVE TO VALIDATE THIS AFTER CREATING
  patch '/flights/:id' do
    flight = Flight.find_by(params[:id])
    if Flight.find_by(mission_number: params[:flight][:mission_number]) && params[:flight][:mission_number] != flight.mission_number
        flash[:message] = "A Flight Associated With This Mission Number Already Exists.  Please Try Again."
        redirect "/flights/#{flight.id}/edit"
    elsif params[:flight][:duration].to_f <= 0
      flash[:message] = "You must enter a duration greater than 0.0"
      redirect "/flights/#{flight.id}/edit"
    else
      flight.update(params[:flight])
      flight.save
      redirect "/flights/#{flight.id}"
    end
  end

  get '/flights/:id/delete' do
    flight = Flight.find(params[:id])
    if student_logged_in?
      flash[:message] = "Sorry, Only Instructors May Delete A Flight."
      redirect "/flights/#{flight.id}"
    elsif !instructor_logged_in?
      redirect "/flights/#{flight.id}"
    elsif current_instructor != flight.instructor
      flash[:message] = "Sorry, Only #{flight.instructor.name} May Delete #{flight.callsign}."
      redirect "/flights/#{flight.id}"
    else
      @flight = Flight.find(params[:id])
      erb :'flights/delete'
    end
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
