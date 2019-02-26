class Changetodecimal < ActiveRecord::Migration
  def change
  	change_column :splices, :dpsi, :decimal, precision: 9, scale: 8
  end
end
