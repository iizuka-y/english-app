module EvaluationsHelper

  def post_star(user, post)
    Evaluation.find_by(user_id: user.id, post_id: post.id).star_count
  end

end
