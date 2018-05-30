class FlightController < ApplicationController

  get '/flights' do
    if ip_or_stud_logged_in?
      @flights = Flight.all
      erb :'/flights/index'
    else
      go_log_in
    end
  end

  get '/flights/new' do
    if instructor_logged_in?
      erb :'flights/new'
    elsif student_logged_in?
      flash[:message] = "Sorry, Only Instructors May Create A New Flight."
      redirect "/flights"
    else
      go_log_in
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
      flight.instructor = Instructor.find_by(name: params[:ip_name]) if params[:ip_name] != "None"
      flight.student = Student.find_by(name: params[:student_name]) if params[:student_name] != "None"
      flight.save
      redirect "/flights/#{flight.id}"
    end
  end

  get '/flights/:id' do
    if ip_or_stud_logged_in?
      @flight = Flight.find(params[:id])
      erb :'/flights/show'
    else
      go_log_in
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

  patch '/flights/:id' do
    flight = Flight.find_by_id(params[:id])
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
    @flight = Flight.find_by_id(params[:id])
    if instructor_logged_in? && current_instructor == @flight.instructor
      erb :'flights/delete'
    elsif instructor_logged_in? && current_instructor != @flight.instructor
      flash[:message] = "Sorry, Only #{@flight.instructor.name} May Delete #{@flight.callsign}."
      redirect "/flights/#{@flight.id}"
    elsif student_logged_in?
      flash[:message] = "Sorry, Only Instructors May Delete A Flight."
      redirect "/flights/#{@flight.id}"
    else
      go_log_in
    end
  end

  delete '/flights/:id/delete' do
    flight = Flight.find_by_id(params[:id])
    if current_instructor.authenticate(params[:instructor_password])
      flight.delete
      flash[:message] = "Successfully Deleted Flight!"
      redirect "/flights"
    end
    flash[:message] = "Incorrect Password.  Please Try Again."
    redirect "/flights/#{flight.id}/delete"
  end

end
