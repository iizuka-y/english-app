class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      # ↑チェックボックスがONならば記憶トークンを生成してハッシュ化した値を記憶ダイジェストとしてDBに保存
      redirect_back_or user
    else
      flash.now[:danger] = "メールアドレスまたはパスワードが間違っています"
      render 'new'
    end
  end

  def destroy
    log_out if logged_in? # ログインしている場合はログイン情報を破棄
    redirect_to root_url
  end
end
