class CommentsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:destroy]

  def create
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      flash[:success] = "コメントを送信しました！"
      redirect_to post_url(params[:post_id])
    else
      @post = Post.find(params[:post_id])
      render 'posts/show'
    end
  end

  def destroy
    @comment.destroy
    redirect_to post_url(params[:post_id])
  end

  private
    def comment_params
      params.require(:comment).permit(:content, :post_id, :id)
    end



  # beforeアクション
  # 正しいユーザーかどうか確認
  def correct_user
    @comment = Comment.find_by(comment_params)
    redirect_to post_url(params[:post_id]) unless current_user?(@comment.user)
  end

end
