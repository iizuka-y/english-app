class CommentsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:destroy]
  after_action :create_notifications, only: [:create]

  def create
    @comment = current_user.comments.build(comment_params)
    @post = Post.find(params[:post_id])
    if @comment.save
      flash[:success] = "コメントを送信しました！"
      redirect_to post_url(params[:post_id])
    else
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

    def create_notifications
      return if @post.user_id == current_user.id || @comment.save == false
      # 自分の投稿に表示したとき、またはコメントの保存に失敗したらリターン
      Notification.create(user_id: @post.user_id,
                          notified_by_id: current_user.id,
                          post_id: @post.id,
                          notified_type: "コメント",
                          read: false,
                          comment_id: @comment.id)
    end

  # beforeアクション
  # 正しいユーザーかどうか確認
  def correct_user
    @comment = Comment.find_by(comment_params)
    redirect_to post_url(params[:post_id]) unless current_user?(@comment.user)
  end

end
