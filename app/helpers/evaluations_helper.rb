module EvaluationsHelper

  def post_star(user, post)
    Evaluation.find_by(user_id: user.id, post_id: post.id).star_count
  end

  def sum_star(post) # あるpostの★の合計数を計算する
    i = 0
    post.evaluations.each do |evaluation|
      i += evaluation.star_count
    end
    return i
  end

  def sum_stars(posts) #たくさんのpostの★の合計数を計算する
    i = 0
    posts.each do |post|
      i += sum_star(post)
    end
    return i
  end

end
