class MutesController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:create]

  def create
    mute = current_user.active_mutes.build(muted_id: params[:user_id])
    if mute.save
      flash[:success] = "#{@user.name}さんの投稿は今後トップページ上に表示されません"
      redirect_to request.referer
    else
      flash[:danger] = "ミュートできませんでした"
      redirect_to root_url
    end
  end

  def destroy
    mute = current_user.active_mutes.find_by(muted_id: params[:user_id])
    mute.destroy
    redirect_to request.referer
  end

  private
    # 自分自身はミュートできないようにする
    def correct_user
      @user = User.find(params[:user_id])
      redirect_to root_url if current_user?(@user)
    end

end
