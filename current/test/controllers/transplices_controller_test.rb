require 'test_helper'

class TransplicesControllerTest < ActionController::TestCase
  setup do
    @transplice = transplices(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:transplices)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create transplice" do
    assert_difference('Transplice.count') do
      post :create, transplice: { gene: @transplice.gene, psi: @transplice.psi, sample_id: @transplice.sample_id, transcript: @transplice.transcript }
    end

    assert_redirected_to transplice_path(assigns(:transplice))
  end

  test "should show transplice" do
    get :show, id: @transplice
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @transplice
    assert_response :success
  end

  test "should update transplice" do
    patch :update, id: @transplice, transplice: { gene: @transplice.gene, psi: @transplice.psi, sample_id: @transplice.sample_id, transcript: @transplice.transcript }
    assert_redirected_to transplice_path(assigns(:transplice))
  end

  test "should destroy transplice" do
    assert_difference('Transplice.count', -1) do
      delete :destroy, id: @transplice
    end

    assert_redirected_to transplices_path
  end
end
