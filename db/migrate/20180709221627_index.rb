class Index < ActiveRecord::Migration
  def change
  	
  	 add_index :abundances, :sample_id
      add_index :abundances, :target_id
      add_index :abundances, :length
      add_index :abundances, :eff_length
      add_index :abundances, :est_counts
      add_index :abundances, :tpm
  end
end
