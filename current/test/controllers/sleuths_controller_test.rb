require 'test_helper'

class SleuthsControllerTest < ActionController::TestCase
  setup do
    @sleuth = sleuths(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sleuths)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sleuth" do
    assert_difference('Sleuth.count') do
      post :create, sleuth: { degrees_free: @sleuth.degrees_free, ens_gene: @sleuth.ens_gene, ext_gene: @sleuth.ext_gene, final_sigma_sq: @sleuth.final_sigma_sq, mean_obs: @sleuth.mean_obs, pval: @sleuth.pval, qval: @sleuth.qval, rsssigma_sq: @sleuth.rsssigma_sq, sigma_sq_pmax: @sleuth.sigma_sq_pmax, smooth_sigma_sq: @sleuth.smooth_sigma_sq, target_id: @sleuth.target_id, tech_var: @sleuth.tech_var, test_stat: @sleuth.test_stat, var_obs: @sleuth.var_obs }
    end

    assert_redirected_to sleuth_path(assigns(:sleuth))
  end

  test "should show sleuth" do
    get :show, id: @sleuth
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sleuth
    assert_response :success
  end

  test "should update sleuth" do
    patch :update, id: @sleuth, sleuth: { degrees_free: @sleuth.degrees_free, ens_gene: @sleuth.ens_gene, ext_gene: @sleuth.ext_gene, final_sigma_sq: @sleuth.final_sigma_sq, mean_obs: @sleuth.mean_obs, pval: @sleuth.pval, qval: @sleuth.qval, rsssigma_sq: @sleuth.rsssigma_sq, sigma_sq_pmax: @sleuth.sigma_sq_pmax, smooth_sigma_sq: @sleuth.smooth_sigma_sq, target_id: @sleuth.target_id, tech_var: @sleuth.tech_var, test_stat: @sleuth.test_stat, var_obs: @sleuth.var_obs }
    assert_redirected_to sleuth_path(assigns(:sleuth))
  end

  test "should destroy sleuth" do
    assert_difference('Sleuth.count', -1) do
      delete :destroy, id: @sleuth
    end

    assert_redirected_to sleuths_path
  end
end
