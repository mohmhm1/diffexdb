class Indextransplices < ActiveRecord::Migration
  def change
  	add_index :transplices, :sample_id
  	add_index :transplices, :gene
  	add_index :transplices, :transcript
  	add_index :transplices, :psi
  end
end
