class Changecolumntonull < ActiveRecord::Migration
  def change
  	change_column_null :sleuths, :created_at, true
  	change_column_null :sleuths, :updated_at, true
  end
end
