class Addnotesandflagtotranscplices < ActiveRecord::Migration
  def change
  	add_column :transplices, :notes, :string
  	add_column :transplices, :flag, :boolean
  end
end
