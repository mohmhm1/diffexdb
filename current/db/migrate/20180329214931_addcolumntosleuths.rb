class Addcolumntosleuths < ActiveRecord::Migration
  def change
  add_column :sleuths, :rss, :decimal
  end
end
