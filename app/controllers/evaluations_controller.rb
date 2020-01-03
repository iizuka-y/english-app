class EvaluationsController < ApplicationController
  before_action :logged_in_user
  after_action :create_notifications, only: [:create]

  def create
    @post = Post.find(params[:post_id])
    @evaluation = current_user.evaluations.build(post_id: params[:post_id], star_count: params[:star_count])
    @evaluation.save

    respond_to do |format|
      format.html { redirect_to request.referer }
      format.js
    end

  end

  def destroy
    @post = Post.find(params[:post_id])
    @evaluation = Evaluation.find_by(user_id: current_user.id, post_id: params[:post_id])
    @evaluation.destroy

    respond_to do |format|
      format.html { redirect_to request.referer }
      format.js
    end

  end

  private
    def create_notifications
      return if @post.user_id == current_user.id # 自分の投稿を評価したときはリターン
      Notification.create(user_id: @post.user_id,
                          notified_by_id: current_user.id,
                          post_id: @post.id,
                          notified_type: "評価",
                          read: false,
                          evaluation_id: @evaluation.id)
    end

end
