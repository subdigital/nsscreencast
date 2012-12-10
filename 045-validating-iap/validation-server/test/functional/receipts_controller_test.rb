require 'test_helper'

class ReceiptsControllerTest < ActionController::TestCase
  test "should get validate" do
    get :validate
    assert_response :success
  end

end
