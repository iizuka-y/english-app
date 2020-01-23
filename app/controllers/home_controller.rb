class HomeController < ApplicationController
  before_action :logged_in_user, only: [:create, :notification]
  before_action :ranking_user, only: [:index, :notification, :favorite]

  def index
    if logged_in?
      mute_ids = "SELECT muted_id FROM mutes WHERE muting_id = #{current_user.id}"

      if params[:id] == "popular" && params[:q] # 人気の投稿かつ検索時
        posts = Post.where("NOT user_id IN (#{mute_ids})").tagged_with(params[:q]).page(params[:page]).per(10)
        @posts = []
        posts.each do |post|
          if sum_star(post) >= 5
            @posts << post
          end
        end
        @posts = Kaminari.paginate_array(@posts).page(params[:page]).per(10)
        @tag = params[:q]
        @post_category = 0


      elsif params[:id] == "ranking" && params[:q] # ランキングかつ検索時
        @posts = Post.where("NOT user_id IN (#{mute_ids})").reorder('star_count DESC', 'created_at DESC').tagged_with(params[:q]).page(params[:page]).per(10)
        @tag = params[:q]
        @post_category = 1


      elsif params[:id] == "popular" # 人気の投稿
        posts = Post.where("NOT user_id IN (#{mute_ids})")
        @posts = []
        posts.each do |post|
          if sum_star(post) >= 5
            @posts << post
          end
        end
        @posts = Kaminari.paginate_array(@posts).page(params[:page]).per(10)
        @post_category = 2


      elsif params[:id] == "ranking" # ランキング
        @posts = Post.where("NOT user_id IN (#{mute_ids})").reorder('star_count DESC', 'created_at DESC').page(params[:page]).per(10)
        @post_category = 3

      elsif params[:q] # タグ検索時
        # @posts = Post.search_by_keyword(params[:q]).where("NOT user_id IN (#{mute_ids})").page(params[:page]).per(10)
        @posts = Post.where("NOT user_id IN (#{mute_ids})").tagged_with(params[:q]).page(params[:page]).per(10)
        @tag = params[:q]
        @post_category = 4


      else # 通常のトップページ
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
