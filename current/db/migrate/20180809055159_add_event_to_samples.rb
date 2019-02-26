class AddEventToSamples < ActiveRecord::Migration
  def change
  	add_column :samples, :event, :integer
  end
end
