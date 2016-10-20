class UsersController < ApplicationController
  before_action :require_login, except: [:login, :index, :new, :create, :logout]
  before_action :require_correct_user, only: [:edit, :update, :destroy]

  def require_login
    redirect_to '/' if session[:user_id] == nil
  end

  def require_correct_user
    user = User.find(params[:id])
    current_user = User.find(session[:user_id])
    redirect_to "/users/#{current_user.id}" if current_user != user
  end

  def index
  end

  def edit
  end


  def create
    user = User.new(first_name:params[:first_name], last_name:params[:last_name], email:params[:email], city:params[:city], state:params[:state], password:params[:password], password_confirmation:params[:passconf])
    if user.save
      session[:user_id] = user.id
      session[:user_name] = user.first_name
      redirect_to '/events/index'
    else
      flash[:messages] = user.errors.full_messages
      redirect_to :back
    end
  end

  def login
    user = User.find_by_email(params[:email])
    if user == nil
      flash[:messages] =["Email not found"]
      redirect_to :back
    elsif user.authenticate(params[:password])
      session[:user_id] = user.id
      session[:user_name] = user.first_name
      redirect_to '/events/index'
    else
      flash[:messages] = user.errors.full_messages
      redirect_to :back
    end

  end

  def edit
    @user = User.find(session[:user_id])
  end

  def update
    user = User.find(params[:id])
    user.assign_attributes(first_name: params[:first_name], last_name: params[:last_name], email: params[:email], city: params[:city], state: params[:state])
    if user.save
      redirect_to "/events/index"
    else
      flash[:messages] = user.errors.full_messages
      redirect_to :back
    end
  end

  def logout
    session.destroy
    redirect_to :root
  end
end
