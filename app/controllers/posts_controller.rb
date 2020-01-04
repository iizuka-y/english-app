class PostsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user,   only: [:edit, :update, :destroy]

  def show
    @post = Post.find(params[:id])
    @comment = current_user.comments.build
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to root_url
      flash[:success] = "投稿しました！"
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @post.update_attributes(post_params)
      flash[:success] = "投稿を更新しました"
      redirect_to @post
    else
      render 'edit'
    end
  end

  def destroy
    @post.destroy
    flash[:success] = "投稿を削除しました！"
    redirect_to request.referrer || root_url #request.referrerメソッドは一つ前のURLを返す
  end

  private
    def post_params
      params.require(:post).permit(:keyword, :content, :information, :image, :image_cache)
    end

    def correct_user
      @post = current_user.posts.find_by(id: params[:id])
      redirect_to root_url if @post.nil?
    end
end
