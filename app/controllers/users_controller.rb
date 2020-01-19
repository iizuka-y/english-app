class UsersController < ApplicationController
  before_action :logged_in_user, only: [:show, :edit, :update, :destroy, :evaluated]
  before_action :correct_user,   only: [:edit, :update, :destroy]
  before_action :ranking_user, only: [:show, :evaluated]
  after_action :edit_star_count, only: [:destroy]

  def show
     @user = User.find(params[:id])
     @posts = @user.posts.page(params[:page]).per(10)
     @post_category = 0
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      redirect_to @user #redirect_to user_url(id: @user.id)
      flash[:success] = "面白英作文へようこそ！"
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "プロフィールを更新しました"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @delete_user = User.find(params[:id])
    @users = []
    @delete_user.evaluations.each do |evaluation|
      @users << evaluation.post.user
    end
    @delete_user.destroy
    flash[:success] = "ユーザーアカウントを削除しました"
    redirect_to root_url
  end

  def evaluated
    @user = User.find(params[:id])
    @posts = @user.evaluate_posts.page(params[:page]).per(10)
    @post_category = 1
    render 'show'
  end



  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :self_introduction)
    end

    # beforeアクション
    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def ranking_user
      @ranking_users = User.limit(10).order('star_count DESC')
    end

    # afterアクション
    # ユーザー削除後に星獲得数を更新
    def edit_star_count
      @users.each do |user|
        user.star_count = sum_stars(user.posts)
        user.save
      end
    end

end
