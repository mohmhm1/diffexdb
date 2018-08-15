json.extract! sleuth, :id, :target_id, :test_stat, :pval, :qval, :rsssigma_sq, :tech_var, :mean_obs, :var_obs, :sigma_sq_pmax, :smooth_sigma_sq, :final_sigma_sq, :degrees_free, :ens_gene, :ext_gene, :created_at, :updated_at
json.url sleuth_url(sleuth, format: :json)
