class Decimal < ActiveRecord::Migration
  def change
  	change_column :abundances, :length, :decimal
  	change_column :abundances, :eff_length, :decimal
  	change_column :abundances, :est_counts, :decimal
  	change_column :abundances, :tpm, :decimal
  end
end
