class UsersController < ApplicationController
  def show
     @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user #redirect_to user_url(id: @user.id)
      flash[:success] = "面白英作文へようこそ！"
    else
      render 'new' #保存が失敗したらnewビューに戻す
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end


end
