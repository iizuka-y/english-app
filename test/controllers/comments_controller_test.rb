require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:マイケル)
    @post = posts(:投稿1)
    @comment = comments(:コメント1)
  end

  test "should redirect evaluation_create when not logged in" do
    assert_no_difference 'Comment.count' do
      post post_comments_path(@post.id), params: { comment:{ user_id: @user.id, post_id: @post.id, content: "コメントです" } }
    end
    assert_redirected_to login_url
  end

  test "should redirect evaluation_destroy when not logged in" do
    assert_no_difference 'Comment.count' do
      delete post_evaluations_path(@post.id)
    end
    assert_redirected_to login_url
  end

end
