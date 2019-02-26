class CreateSplices < ActiveRecord::Migration
  def change
    create_table :splices do |t|
      t.string :sample_id
      t.string :ensembl
      t.string :event
      t.string :coordinates
      t.integer :dpsi
      t.integer :pval

      t.timestamps null: false
    end
  end
end
