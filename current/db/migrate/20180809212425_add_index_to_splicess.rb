class AddIndexToSplicess < ActiveRecord::Migration
  def change
  	add_index :splices, :sample_id
      add_index :splices, :ensembl
      add_index :splices, :event
      add_index :splices, :coordinates
      add_index :splices, :dpsi
      add_index :splices, :pval
  end
end
