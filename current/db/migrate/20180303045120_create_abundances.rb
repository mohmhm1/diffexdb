class CreateAbundances < ActiveRecord::Migration
  def change
    create_table :abundances do |t|
      t.string :sample_id
      t.string :target_id
      t.integer :length
      t.integer :eff_length
      t.integer :est_counts
      t.integer :tpm

      t.timestamps null: false
      
    end
  end
end
