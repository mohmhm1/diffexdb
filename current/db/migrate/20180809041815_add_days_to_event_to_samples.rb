class AddDaysToEventToSamples < ActiveRecord::Migration
  def change
  	add_column :samples, :days_to_event, :integer
  end
end
