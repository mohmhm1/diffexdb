require 'test_helper'

class HcvdrugsControllerTest < ActionController::TestCase
  setup do
    @hcvdrug = hcvdrugs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:hcvdrugs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create hcvdrug" do
    assert_difference('Hcvdrug.count') do
      post :create, hcvdrug: { information: @hcvdrug.information, name: @hcvdrug.name, region: @hcvdrug.region, variant: @hcvdrug.variant }
    end

    assert_redirected_to hcvdrug_path(assigns(:hcvdrug))
  end

  test "should show hcvdrug" do
    get :show, id: @hcvdrug
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @hcvdrug
    assert_response :success
  end

  test "should update hcvdrug" do
    patch :update, id: @hcvdrug, hcvdrug: { information: @hcvdrug.information, name: @hcvdrug.name, region: @hcvdrug.region, variant: @hcvdrug.variant }
    assert_redirected_to hcvdrug_path(assigns(:hcvdrug))
  end

  test "should destroy hcvdrug" do
    assert_difference('Hcvdrug.count', -1) do
      delete :destroy, id: @hcvdrug
    end

    assert_redirected_to hcvdrugs_path
  end
end
