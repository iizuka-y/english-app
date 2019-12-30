require 'test_helper'

class EvaluationsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get evaluations_create_url
    assert_response :success
  end

  test "should get destroy" do
    get evaluations_destroy_url
    assert_response :success
  end

end
