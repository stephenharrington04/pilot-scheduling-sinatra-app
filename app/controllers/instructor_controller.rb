class InstructorController < ApplicationController
  use Rack::Flash

  get '/instructors' do
    instructor_go_log_in
    @instructors = Instructor.all
    erb :'/instructors/index'
  end

  get '/instructors/signup' do
    if instructor_logged_in?
      flash[:message] = "You're already Logged In."
      redirect "/instructors"
    end
    erb :'/instructors/new'
  end

  #hard coded the admin_password for now.  May change to be dynamic later.

  post '/instructors' do
    if Instructor.find_by(email: params[:instructor][:email])
      flash[:message] = "An account associated with this email already exists.  Please try again."
      redirect "/instructors/signup"
    elsif params[:instructor][:password] != params[:password_confirm]
      flash[:message] = "Password does not match Confirm Password.  Please try again."
      redirect "/instructors/signup"
    elsif params[:admin_password] != "instructor password"
      flash[:message] = "Incorrect Admin Password.  Please try again."
      redirect "/instructors/signup"
    else
      instructor = Instructor.create(params[:instructor])
      session[:instructor_id] = instructor.id
      flash[:message] = "Successfully Created an Account!"
      redirect "/instructors/#{instructor.slug}"
    end
  end

  get '/instructors/login' do
    if instructor_logged_in?
      flash[:message] = "You're already Logged In."
      redirect "/instructors"
    end
    erb :'/instructors/login'
  end

  post '/instructors/login' do
    instructor = Instructor.find_by(email: params[:email])
    if instructor && instructor.authenticate(params["password"])
      session[:instructor_id] = instructor.id
      flash[:message] = "Successfully Logged In!"
      redirect "/instructors/#{instructor.slug}"
    end
    flash[:message] = "Incorrect Email and/or Password."
    redirect "/instructors/login"
  end

  get '/instructors/:slug' do
    instructor_go_log_in
    @instructor = Instructor.find_by_slug(params[:slug])
    erb :'/instructors/show'
  end

  get '/instructors/:slug/edit' do
    instructor_go_log_in
    @instructor = Instructor.find_by_slug(params[:slug])
    if current_instructor != @instructor
      flash[:message] = "You do not have permissions to edit THAT page."
      redirect "/instructors"
    end
    erb :'/instructors/edit'
  end

  patch '/instructors/:slug' do
    instructor = Instructor.find_by_slug(params[:slug])
    if params[:instructor][:password] != params[:password_confirm]
      flash[:message] = "New Password does not match Confirm Password.  Please Try Again."
      redirect "/instructors/#{instructor.slug}/edit"
    elsif Instructor.find_by(email: params[:instructor][:email]) && params[:instructor][:email] != instructor.email
      flash[:message] = "An account associated with this email already exists.  Please try again."
      redirect "/instructors/#{instructor.slug}/edit"
    elsif instructor && current_instructor.authenticate(params[:current_password])
      instructor.update(params[:instructor])
      instructor.save
      flash[:message] = "Account Successfully Updated!"
      redirect "/instructors/#{instructor.slug}"
    else
      flash[:message] = "Current Password was incorrect.  Please Try Again."
      redirect "/instructors/#{instructor.slug}/edit"
    end
  end

  get '/instructors/:slug/delete' do
    instructor_go_log_in
    @instructor = Instructor.find_by_slug(params[:slug])
    if current_instructor != @instructor
      flash[:message] = "You do not have permissions to Delete that account."
      redirect "/instructors"
    end
    erb :'/instructors/delete'
  end

  delete '/instructors/:slug/delete' do
    if current_instructor.authenticate(params[:password])
      current_instructor.delete
      session.clear
      flash[:message] = "Successfully Deleted Account!"
      redirect "/"
    end
    flash[:message] = "Incorrect Password.  Please Try Again."
    redirect "/instructors/#{current_instructor.slug}/delete"
  end

end
