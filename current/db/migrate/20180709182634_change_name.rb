class ChangeName < ActiveRecord::Migration
  def change
  	rename_column :samples, :bcr_patient_barcode, :sample_id
  end
end
