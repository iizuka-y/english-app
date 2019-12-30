class EvaluationsController < ApplicationController
  before_action :logged_in_user

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

end
