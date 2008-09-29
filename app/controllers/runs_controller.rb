class RunsController < ApplicationController
  def index
    if params[:user_id]
      @user = User.find(params[:user_id])
    else
      @user = current_user
      list_of_friends = (params[:fb_sig_friends]||"").split(/,/)
      @friends_runs = Run.find_for_friends(list_of_friends)
    end
    
    @runs = @user.runs
    
  end
  
  def cheer
    @run = Run.find(params[:id])
    UserPublisher.deliver_cheer(current_user,@run)
    flash[:notice] = "Thanks for cheering!"
    redirect_to user_runs_path(@run.user)
  end
  
  def new
    @run = Run.new
  end
  
  def create
    current_user.runs.create(params[:run])
    redirect_to runs_path
  end
end
