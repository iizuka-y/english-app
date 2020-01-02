require 'test_helper'

class MuteTest < ActiveSupport::TestCase
  def setup
    @mute = Mute.new(muting_id: users(:マイケル).id, muted_id: users(:太郎).id)
  end

  test "should be valid" do
    assert @mute.valid?
  end

  test "should require a muting_id" do
    @mute.muting_id = nil
    assert_not @mute.valid?
  end

  test "should require a muted_id" do
    @mute.muted_id = nil
    assert_not @mute.valid?
  end

end
