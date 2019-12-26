class PostsController < ApplicationController
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

  private
    def post_params
      params.require(:post).permit(:keyword, :content, :information)
    end
end
