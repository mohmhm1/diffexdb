class CreateVariants < ActiveRecord::Migration
  def change
    create_table :variants do |t|
      t.string :AAchange
      t.string :genotype
      t.string :drugrelation
      t.text :information

      t.timestamps null: false
    end
  end
end
