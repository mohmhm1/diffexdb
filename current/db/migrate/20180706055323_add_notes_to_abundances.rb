class AddNotesToAbundances < ActiveRecord::Migration
  def change
    add_column :abundances, :notes, :string
  end
end
