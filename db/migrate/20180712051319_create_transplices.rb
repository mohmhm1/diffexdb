class CreateTransplices < ActiveRecord::Migration
  def change
    create_table :transplices do |t|
      t.string :gene
      t.string :transcript
      t.decimal :psi
      t.string :sample_id

      t.timestamps null: false
    end
  end
end
