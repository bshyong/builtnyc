class AddRelationshipBetweenFirmsAndPlaces < ActiveRecord::Migration
  def change
    add_column :places, :firm_id, :integer
    add_index :places, :firm_id
  end
end
