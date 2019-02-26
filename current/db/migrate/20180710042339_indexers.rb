class Indexers < ActiveRecord::Migration
  def change
  	add_index :abundances, :flag
  	add_index :abundances, :created_at
  	add_index :abundances, :updated_at
  	add_index :abundances, :notes
  	add_index :samples, :sample_id
  end
end
