class LikesController < ApplicationController
  before_action :find_micropost
  before_action :find_like, only: [:destroy]
  
  def create
    if already_liked?
      flash[:notice] = "You can't like more than once"
    else
      @micropost.likes.create(user_id: current_user.id)
    end
    
    respond_to do |format|
      format.html { redirect_to (request.referer ? request.referer : user_path(@micropost.user)) }
      format.js
    end
  end
  
  def destroy
    if !(already_liked?)
      flash[:notice] = "Cannot unlike"
    else
      @like.destroy
    end
    
    respond_to do |format|
      format.html { redirect_to (request.referer ? request.referer : user_path(@micropost.user)) }
      format.js
    end
  end
  
  def find_like
    @like = @micropost.likes.find(params[:id])
  end
  
  private
  
  def find_micropost
    @micropost = Micropost.find(params[:micropost_id])
  end
  
  def already_liked?
    Like.where(user_id: current_user.id, micropost_id: params[:micropost_id]).exists?
  end
end
