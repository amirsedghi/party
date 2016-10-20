class EventsController < ApplicationController
  before_action :require_login
  before_action :require_correct_user, only: [:edit, :update, :destroy]

  def require_login
    redirect_to '/' if session[:user_id] == nil
  end

  def require_correct_user
    user = Event.find(params[:id]).user
    current_user = User.find(session[:user_id])
    redirect_to "/events/index" if current_user != user
  end

  def index
    @user = User.find(session[:user_id])

    # ask eduardo
    @events_joined = Attendee.where(user: @user).select(:event_id)
    @attending = []
    @events_joined.each do |event|
      @attending << event.event_id
    end

    @events = Event.joins(:user).where(state: @user.state).select(:name, :state, :date, :city, :first_name, "events.id as id", "users.id as user_id")

    @outer_events = Event.joins(:user).where.not(state: @user.state).select(:name, :state, :date, :city, :first_name, "events.id as id", "users.id as user_id")

    # @going = User.joins(:events).where(id: session[:user_id])
    # @not_going =  Event.joins(:user).where(state: @user.state).select("*") - @going
    # @other_events =  Event.joins(:user).where.not(state: @user.state).select("*")
  end

  def create
    user = User.find(session[:user_id])
    event = Event.new(name: params[:name], date: params[:date], city: params[:city], state: params[:state], user: user)
    if event.save
      redirect_to :back
    else
      flash[:messages]=event.errors.full_messages
      redirect_to :back
    end

  end

  def edit
    @event = Event.find(params[:id])
    @date = @event.date.strftime('%Y-%m-%d')
  end

  def update
    event = Event.find(params[:id])
    event.assign_attributes(name: params[:name], date: params[:date], city: params[:city], state: params[:state])

    if event.save
      redirect_to '/events/index'
    else
      flash[:messages]=event.errors.full_messages
      redirect_to :back
    end
  end

  def destroy
    Event.find(params[:id]).destroy
    redirect_to :back
  end

  def join
    user = User.find(session[:user_id])
    event = Event.find(params[:id])
    if Attendee.find_by(user:user, event:event)
      flash[:messages] = ["Already Attending"]
    else
      Attendee.create(user: user, event:event)
    end
    redirect_to :back
  end

  def attend_destroy
    user = User.find(session[:user_id])
    event = Event.find(params[:id])
    Attendee.find_by(user:user, event:event).destroy
    redirect_to :back
  end

  def event_page
    @event = Event.joins(:user).where(id: params[:id]).select(:first_name, :last_name, :date, :city, :state, :name, "events.id as id")
    @attendees = Event.find(params[:id]).users
    @count = @attendees.count
    @comments = Event.joins(:comments).joins(comments: :user).select("*")
  end

end
