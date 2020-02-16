class FavoritesController < ApplicationController
  before_action :logged_in_user
  before_action :ranking_user, only: [:create]

  def create
    @favorite = current_user.favorites.build(favorite_params)
    @post = @favorite.post
    @favorite.save!
    @categories = current_user.favorites.pluck(:category).uniq
    respond_to do |format|
      format.html { redirect_to request.referer }
      format.js
    end
  end

  def update
    favorites = current_user.favorites.where("category = '#{params[:category_prev]}'")
    favorites.each do |favorite|
      favorite.category = params[:favorite][:category]
      favorite.save!
    end
    redirect_to favorite_url
  end

  def delete # 例文帳のカテゴリー削除
    favorites = current_user.favorites.where("category = '#{params[:favorite][:category]}'")
    favorites.destroy_all
    redirect_to favorite_url
  end

  def destroy # 例文帳の登録解除
    favorite = current_user.favorites.find_by(post_id: params[:post_id])
    @post = Post.find(params[:post_id])
    favorite.destroy
    respond_to do |format|
      format.html { redirect_to request.referer }
      format.js
    end
  end

  private
    def favorite_params
      params.require(:favorite).permit(:category, :post_id)
    end

    def favorite_params2
      params.require(:favorite).permit(:category)
    end

    def ranking_user
      @ranking_users = User.limit(10).order('star_count DESC')
    end

end
