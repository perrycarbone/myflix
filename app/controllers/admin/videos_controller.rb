class Admin::VideosController < ApplicationController
  before_action :require_user
  before_action :require_admin

  def new
    @video = Video.new
  end

  def create
    @video = Video.create(video_params)

    if @video.save
      flash[:success] = "The video has been added."
      redirect_to new_admin_video_path
    else
      flash.now[:danger] = "Please fill out all required fields."
      render :new
    end
  end

  private

  def require_admin
    if !current_user.admin?
      flash[:danger] = "You do not have permission to do that."
      redirect_to home_path
    end
  end

  def video_params
    params.require(:video).permit(:title, :category_id, :description)
  end
end
