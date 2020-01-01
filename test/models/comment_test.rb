require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  def setup
    @comment = Comment.new(user_id: users(:マイケル).id, post_id: posts(:投稿3).id, content: "コメントです")
  end

  test "should be valid" do
    assert @comment.valid?
  end

  test "should require a user_id" do
    @comment.user_id = nil
    assert_not @comment.valid?
  end

  test "should require a post_id" do
    @comment.post_id = nil
    assert_not @comment.valid?
  end

  test "should require a content" do
    @comment.content = nil
    assert_not @comment.valid?
  end
end
