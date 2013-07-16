class ChangeColumnNameOnPlaces < ActiveRecord::Migration
  def change
    rename_column :places, :nhrp_ref, :nrhp_ref
  end
end
