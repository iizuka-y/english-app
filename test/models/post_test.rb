require 'test_helper'

class PostTest < ActiveSupport::TestCase

  def setup
    @user = users(:マイケル)
    @post = @user.posts.build(keyword:"test", content: "testだよ！", information: "testです")
  end

  test "should be valid" do
    assert @post.valid?
  end

  test "user id should be present" do
    @post.user_id = nil
    assert_not @post.valid?
  end

  test "keyword should be present" do
    @post.keyword = ""
    assert_not @post.valid?
  end

  test "content should be present" do
    @post.content = ""
    assert_not @post.valid?
  end

  test "content should be at most 200 characters" do
    @post.content = "a" * 201
    assert_not @post.valid?
  end

  test "information don't have to be present" do
    @post.information = ""
    assert @post.valid?
  end

  test "order should be most recent first" do
    assert_equal posts(:最新の投稿), Post.first
  end

end
