class RelationshipsController < ApplicationController

  def create
    user = User.find(params[:user_id])
    current_user.follow(user) #user.rbで定義したfollowメソッド呼び出し
    redirect_back(fallback_location: root_path)
  end

  def destroy
    user = User.find(params[:user_id])
    current_user.unfollow(user) #user.rbで定義したunfollowメソッド呼び出し
    redirect_back(fallback_location: root_path)
  end

end
