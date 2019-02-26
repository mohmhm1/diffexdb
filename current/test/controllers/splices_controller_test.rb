require 'test_helper'

class SplicesControllerTest < ActionController::TestCase
  setup do
    @splice = splices(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:splices)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create splice" do
    assert_difference('Splice.count') do
      post :create, splice: { coordinates: @splice.coordinates, dpsi: @splice.dpsi, ensembl: @splice.ensembl, event: @splice.event, pval: @splice.pval, sample_id: @splice.sample_id }
    end

    assert_redirected_to splice_path(assigns(:splice))
  end

  test "should show splice" do
    get :show, id: @splice
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @splice
    assert_response :success
  end

  test "should update splice" do
    patch :update, id: @splice, splice: { coordinates: @splice.coordinates, dpsi: @splice.dpsi, ensembl: @splice.ensembl, event: @splice.event, pval: @splice.pval, sample_id: @splice.sample_id }
    assert_redirected_to splice_path(assigns(:splice))
  end

  test "should destroy splice" do
    assert_difference('Splice.count', -1) do
      delete :destroy, id: @splice
    end

    assert_redirected_to splices_path
  end
end
