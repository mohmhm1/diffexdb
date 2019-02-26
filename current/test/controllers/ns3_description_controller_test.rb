require 'test_helper'

class Ns3DescriptionControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
