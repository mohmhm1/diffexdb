require 'test_helper'

class VariantsControllerTest < ActionController::TestCase
  setup do
    @variant = variants(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:variants)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create variant" do
    assert_difference('Variant.count') do
      post :create, variant: { AAchange: @variant.AAchange, drugrelation: @variant.drugrelation, genotype: @variant.genotype, information: @variant.information }
    end

    assert_redirected_to variant_path(assigns(:variant))
  end

  test "should show variant" do
    get :show, id: @variant
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @variant
    assert_response :success
  end

  test "should update variant" do
    patch :update, id: @variant, variant: { AAchange: @variant.AAchange, drugrelation: @variant.drugrelation, genotype: @variant.genotype, information: @variant.information }
    assert_redirected_to variant_path(assigns(:variant))
  end

  test "should destroy variant" do
    assert_difference('Variant.count', -1) do
      delete :destroy, id: @variant
    end

    assert_redirected_to variants_path
  end
end
