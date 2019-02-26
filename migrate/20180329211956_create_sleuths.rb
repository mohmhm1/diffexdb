class CreateSleuths < ActiveRecord::Migration
  def change
    create_table :sleuths do |t|
      t.string :target_id
      t.decimal :test_stat
      t.decimal :pval
      t.decimal :qval
      t.decimal :rsssigma_sq
      t.decimal :tech_var
      t.decimal :mean_obs
      t.decimal :var_obs
      t.decimal :sigma_sq_pmax
      t.decimal :smooth_sigma_sq
      t.decimal :final_sigma_sq
      t.integer :degrees_free
      t.string :ens_gene
      t.string :ext_gene

      t.timestamps null: false
    end
  end
end
