class HomeController < ApplicationController
  def index
    if logged_in?
      mute_ids = "SELECT muted_id FROM mutes WHERE muting_id = #{current_user.id}"
      @posts = Post.where("NOT user_id IN (#{mute_ids})")
      # @posts = Post.where("NOT user_id IN (?)", current_user.muting_users.map(&:id))
      # ↑誰もミュートしていないときに@postsがnilになる
    end
  end

  def create # notificationテーブルのreadの中身をtrueにする
    Notification.where("user_id = #{current_user.id}").update_all "read = 'true'"
    redirect_to notification_url
  end

  def notification
    @notifications = Notification.where("user_id = '#{current_user.id}'")
  end
end
