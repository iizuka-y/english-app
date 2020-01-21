class HomeController < ApplicationController
  before_action :logged_in_user, only: [:create, :notification]
  before_action :ranking_user, only: [:index, :notification, :favorite]

  def index
    if logged_in?
      mute_ids = "SELECT muted_id FROM mutes WHERE muting_id = #{current_user.id}"
      if params[:q]
        # @posts = Post.search_by_keyword(params[:q]).where("NOT user_id IN (#{mute_ids})").page(params[:page]).per(10)
        @posts = Post.tagged_with(params[:q]).page(params[:page]).per(10)
        @tag = params[:q]
      else
        @posts = Post.where("NOT user_id IN (#{mute_ids})").page(params[:page]).per(10)
      # @posts = Post.where("NOT user_id IN (?)", current_user.muting_users.map(&:id))
      # ↑誰もミュートしていないときに@postsがnilになる
      end
    end
  end

  def create # notificationテーブルのreadの中身をtrueにする
    Notification.where("user_id = #{current_user.id}").update_all "read = 'true'"
    redirect_to notification_url
  end

  def notification
    @notifications = Notification.where("user_id = '#{current_user.id}'").order(created_at: :desc)
    .page(params[:page]).per(10)
  end

  def favorite
    @favorites = current_user.favorites
    @categories = @favorites.pluck(:category).uniq
    if params[:id]
      @id = params[:id]
      favorites = current_user.favorites.where("category = ?", params[:id]).order(created_at: :desc)
      @posts = Kaminari.paginate_array(favorites.map{|favorite| favorite.post}).page(params[:page]).per(10)
    else
      favorites = current_user.favorites.order(created_at: :desc)
      @posts = Kaminari.paginate_array(favorites.map{|favorite| favorite.post}).page(params[:page]).per(10)
    end
  end


  # beforeアクション
  def ranking_user
    @ranking_users = User.limit(10).order('star_count DESC')
  end



end
