require 'test_helper'

class EvaluationTest < ActiveSupport::TestCase
  def setup
    @evaluation = Evaluation.new(user_id: users(:マイケル).id, post_id: posts(:投稿3).id, star_count: 2)
  end

  test "should be valid" do
    assert @evaluation.valid?
  end

  test "should require a user_id" do
    @evaluation.user_id = nil
    assert_not @evaluation.valid?
  end

  test "should require a post_id" do
    @evaluation.post_id = nil
    assert_not @evaluation.valid?
  end
end
