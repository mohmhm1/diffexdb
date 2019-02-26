class Addboolstattosamples < ActiveRecord::Migration
  def change
  	add_column :samples, :status_bool, :integer
  end
end
