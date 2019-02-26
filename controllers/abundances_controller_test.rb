require 'test_helper'

class AbundancesControllerTest < ActionController::TestCase
  setup do
    @abundance = abundances(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:abundances)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create abundance" do
    assert_difference('Abundance.count') do
      post :create, abundance: { bcr_patient_barcode: @abundance.bcr_patient_barcode, eff_length: @abundance.eff_length, est_counts: @abundance.est_counts, length: @abundance.length, target_id: @abundance.target_id, tpm: @abundance.tpm }
    end

    assert_redirected_to abundance_path(assigns(:abundance))
  end

  test "should show abundance" do
    get :show, id: @abundance
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @abundance
    assert_response :success
  end

  test "should update abundance" do
    patch :update, id: @abundance, abundance: { bcr_patient_barcode: @abundance.bcr_patient_barcode, eff_length: @abundance.eff_length, est_counts: @abundance.est_counts, length: @abundance.length, target_id: @abundance.target_id, tpm: @abundance.tpm }
    assert_redirected_to abundance_path(assigns(:abundance))
  end

  test "should destroy abundance" do
    assert_difference('Abundance.count', -1) do
      delete :destroy, id: @abundance
    end

    assert_redirected_to abundances_path
  end
end
