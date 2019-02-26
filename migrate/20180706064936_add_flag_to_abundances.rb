class AddFlagToAbundances < ActiveRecord::Migration
  def change
    add_column :abundances, :flag, :boolean
  end
end
