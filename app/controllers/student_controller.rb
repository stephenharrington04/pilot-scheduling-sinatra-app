class StudentController < ApplicationController

  get '/students' do
    if instructor_logged_in? || student_logged_in?
      @students = Student.all
      erb :'/students/index'
    else
      flash[:message] = "You muse be logged in to view this page."
      redirect "/"
    end
  end

  get '/students/new' do
    if student_logged_in?
      flash[:message] = "You're already Logged In."
      redirect "/students"
    end
    erb :'/students/new'
  end

  post '/students' do
    if Student.find_by(email: params[:student][:email])
      flash[:message] = "An account associated with this email already exists.  Please try again."
      redirect "/students/new"
    elsif params[:student][:password] != params[:student_confirm]
      flash[:message] = "Password does not match Confirm Password.  Please try again."
      redirect "/students/new"
    else
      student = Student.create(params[:student])
      if instructor_logged_in? == false
        session[:student_id] = student.id
      end
      flash[:message] = "Successfully Created an Account!"
      redirect "/students/#{student.slug}"
    end
  end

  get '/students/login' do
    if student_logged_in? || instructor_logged_in?
      flash[:message] = "You're already Logged In."
      redirect "/students"
    end
    erb :'/students/login'
  end

  post '/students/login' do
    student = Student.find_by(email: params[:email])
    if student && student.authenticate(params["password"])
      session[:student_id] = student.id
      flash[:message] = "Successfully Logged In!"
      redirect "/students/#{student.slug}"
    end
    flash[:message] = "Incorrect Email and/or Password."
    redirect "/students/login"
  end

  get '/students/:slug' do
    if student_logged_in? || instructor_logged_in?
      @student = Student.find_by_slug(params[:slug])
      erb :'/students/show'
    else
      flash[:message] = "You muse be logged in to view this page."
      redirect "/"
    end
  end

  get '/students/:slug/edit' do
    if student_logged_in? || instructor_logged_in?
      @student = Student.find_by_slug(params[:slug])
      if current_student != @student || instructor_logged_in? == false
        flash[:message] = "You do not have permissions to edit THAT page."
        redirect "/students"
      end
    else
      flash[:message] = "You muse be logged in to view this page."
      redirect "/"
    end
    erb :'/students/edit'
  end

  patch '/students/:slug' do
    student = Student.find_by_slug(params[:slug])

    if student_logged_in?
      if params[:student][:password] != params[:password_confirm]
        flash[:message] = "New Password does not match Confirm Password.  Please Try Again."
        redirect "/students/#{student.slug}/edit"
      elsif Student.find_by(email: params[:student][:email]) && params[:student][:email] != student.email
        flash[:message] = "An account associated with this email already exists.  Please try again."
        redirect "/students/#{student.slug}/edit"
      elsif student && current_student.authenticate(params[:current_password])
        student.update(params[:student])
        student.save
        flash[:message] = "Account Successfully Updated!"
        redirect "/students/#{student.slug}"
      else
        flash[:message] = "Current Password was incorrect.  Please Try Again."
        redirect "/students/#{student.slug}/edit"
      end
    end

    if instructor_logged_in?
      if Student.find_by(email: params[:student][:email]) && params[:student][:email] != student.email
        flash[:message] = "An account associated with this email already exists.  Please try again."
        redirect "/students/#{student.slug}/edit"
      elsif student && current_instructor.authenticate(params[:ip_password])
        student.update(params[:student])
        student.save
        flash[:message] = "Account Successfully Updated!"
        redirect "/students/#{student.slug}"
      else
        flash[:message] = "Your Account Password was incorrect.  Please Try Again."
        redirect "/students/#{student.slug}/edit"
      end
    end
  end

  get '/students/:slug/delete' do
    if student_logged_in? || instructor_logged_in?
      @student = Student.find_by_slug(params[:slug])
      if current_student != @student || instructor_logged_in? == false
        flash[:message] = "You do not have permissions to Delete that account."
        redirect "/students"
      end
    else
      flash[:message] = "You muse be logged in to view this page."
      redirect "/"
    end
    erb :'/students/delete'
  end

  delete '/students/:slug/delete' do
    if current_student.authenticate(params[:password]) || current_instructor.authenticate(params[:password])
      current_student.delete
      session.clear
      flash[:message] = "Successfully Deleted Account!"
      redirect "/"
    end
    flash[:message] = "Incorrect Password.  Please Try Again."
    redirect "/students/#{current_student.slug}/delete"
  end

end
