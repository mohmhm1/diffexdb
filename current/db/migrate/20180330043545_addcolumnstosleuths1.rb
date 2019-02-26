class Addcolumnstosleuths1 < ActiveRecord::Migration
  def change
  add_column :sleuths, :biotype, :string
  add_column :sleuths, :model, :string
  end
end
