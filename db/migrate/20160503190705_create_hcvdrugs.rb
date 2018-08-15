class CreateHcvdrugs < ActiveRecord::Migration
  def change
    create_table :hcvdrugs do |t|
      t.string :name
      t.string :region
      t.string :variant
      t.text :information

      t.timestamps null: false
    end
  end
end
