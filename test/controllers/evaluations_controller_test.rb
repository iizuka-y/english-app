require 'test_helper'

class EvaluationsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:マイケル)
    @post = posts(:投稿1)
    @evaluation = evaluations(:評価1)
  end

  test "should redirect evaluation_create when not logged in" do
    assert_no_difference 'Evaluation.count' do
      post post_evaluations_path(@post.id), params: { evaluation:{ user_id: @user.id, post_id: @post.id, star_count: 2 } }
    end
    assert_redirected_to login_url
  end

  test "should redirect evaluation_destroy when not logged in" do
    assert_no_difference 'Evaluation.count' do
      delete post_evaluations_path(@post.id)
    end
    assert_redirected_to login_url
  end

end
