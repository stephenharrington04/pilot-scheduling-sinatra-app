class InstructorController < ApplicationController
  use Rack::Flash

  get '/instructors' do
    if instructor_logged_in? || student_logged_in?
      @instructors = Instructor.all
      erb :'/instructors/index'
    else
      flash[:message] = "You must be logged in to view that page."
      redirect "/"
    end
  end

  get '/instructors/new' do
    if instructor_logged_in?
      flash[:message] = "You're already Logged In."
      redirect "/instructors"
    elsif student_logged_in?
      flash[:message] = "You're already Logged In as a Student"
      redirect "/"
    end
    erb :'/instructors/new'
  end

  #hard coded the admin_password for now.  May change to be dynamic later.

  post '/instructors' do
    if Instructor.find_by(email: params[:instructor][:email])
      flash[:message] = "An account associated with this email already exists.  Please try again."
      redirect "/instructors/new"
    elsif params[:instructor][:password] != params[:password_confirm]
      flash[:message] = "Password does not match Confirm Password.  Please try again."
      redirect "/instructors/new"
    elsif params[:admin_password] != "instructor password"
      flash[:message] = "Incorrect Admin Password.  Please try again."
      redirect "/instructors/new"
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
    elsif student_logged_in?
      flash[:message] = "You're already Logged In as a Student"
      redirect "/"
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
    if instructor_logged_in?
      @instructor = Instructor.find_by_slug(params[:slug])
      erb :'/instructors/show'
    elsif student_logged_in?
      flash[:message] = "Students cannot view individual instructor's profile pages."
      redirect "/"
    else
      flash[:message] = "You must be logged in to view that page."
      redirect "/"
    end
  end

  get '/instructors/:slug/edit' do
    @instructor = Instructor.find_by_slug(params[:slug])
    if instructor_logged_in? && current_instructor == @instructor
      erb :'/instructors/edit'
    elsif instructor_logged_in? && current_instructor != @instructor
      flash[:message] = "You do not have permissions to edit THAT page."
      redirect "/instructors"
    elsif student_logged_in?
      flash[:message] = "Students cannot edit an instructor's profile page."
      redirect "/instructors"
    else
      flash[:message] = "You must be logged in to view that page."
      redirect "/"
    end
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
    @instructor = Instructor.find_by_slug(params[:slug])
    if instructor_logged_in? && current_instructor == @instructor
      erb :'/instructors/delete'
    elsif instructor_logged_in? && current_instructor != @instructor
      flash[:message] = "You do not have permissions to delete THAT profile."
      redirect "/instructors"
    elsif student_logged_in?
      flash[:message] = "Students cannot delete an instructor's profile page."
      redirect "/instructors"
    else
      flash[:message] = "You must be logged in to view that page."
      redirect "/"
    end
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
