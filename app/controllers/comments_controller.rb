class CommentsController < ApplicationController
  def create
    event = Event.find(params[:id])
    user = User.find(session[:user_id])
    Comment.create(user: user, event: event, comment: params[:comment])
    redirect_to "/events/#{params[:id]}"
  end
end
