class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  include EvaluationsHelper

  private
  # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        store_location # アクセスしようとしたURLを覚えておく
        flash[:danger] = "ログインしてください"
        redirect_to login_url
        #beforeアクション内でrenderやredirectすると後続のbefore_actionやactionはキャンセルされる
      end
    end

end
