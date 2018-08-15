class Changetimetonullfortransplices < ActiveRecord::Migration
  def change
  	change_column_null :transplices, :created_at, true
  	change_column_null :transplices, :updated_at, true
  end
end
