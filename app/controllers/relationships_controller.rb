class RelationshipsController < ApplicationController
  before_action :require_user

  def create
    leader = User.find(params[:leader_id])
    Relationship.create(leader: leader, follower: current_user) if current_user.can_follow?(leader)
    redirect_to people_path
  end

  def index
    @relationships = current_user.following_relationships
  end

  def destroy
    relationship = Relationship.find(params[:id])

    if relationship.follower == current_user
      relationship.destroy
      redirect_to people_path
    else
      flash[:danger] = "You do not have permission to do that."
      redirect_to root_path
    end
  end
end
