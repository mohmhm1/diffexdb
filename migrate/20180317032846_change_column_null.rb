class ChangeColumnNull < ActiveRecord::Migration
  def change
  	change_column_null :splices, :created_at, true
  	change_column_null :splices, :updated_at, true
  	change_column_null :abundances, :created_at, true
  	change_column_null :abundances, :updated_at, true
  	change_column_null :samples, :created_at, true
  	change_column_null :samples, :updated_at, true
  
  	
  end
end
