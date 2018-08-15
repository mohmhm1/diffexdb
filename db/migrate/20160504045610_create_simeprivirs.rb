class CreateSimeprivirs < ActiveRecord::Migration
  def change
    create_table :simeprivirs do |t|

      t.timestamps null: false
    end
  end
end
