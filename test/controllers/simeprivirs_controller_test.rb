require 'test_helper'

class SimeprivirsControllerTest < ActionController::TestCase
  setup do
    @simeprivir = simeprivirs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:simeprivirs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create simeprivir" do
    assert_difference('Simeprivir.count') do
      post :create, simeprivir: {  }
    end

    assert_redirected_to simeprivir_path(assigns(:simeprivir))
  end

  test "should show simeprivir" do
    get :show, id: @simeprivir
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @simeprivir
    assert_response :success
  end

  test "should update simeprivir" do
    patch :update, id: @simeprivir, simeprivir: {  }
    assert_redirected_to simeprivir_path(assigns(:simeprivir))
  end

  test "should destroy simeprivir" do
    assert_difference('Simeprivir.count', -1) do
      delete :destroy, id: @simeprivir
    end

    assert_redirected_to simeprivirs_path
  end
end
