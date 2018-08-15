class CreatePatients < ActiveRecord::Migration
  def change
    create_table :patients do |t|
      t.string :FirstName
      t.string :LastName
      t.date :DOB
      t.string :Genotype
      t.string :Mutations
      t.string :Treatment
      t.string :Physician

      t.timestamps null: false
    end
  end
end
