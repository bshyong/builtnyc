class AddColumnsToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :name, :string
    add_column :places, :location, :string
    add_column :places, :latitude, :string
    add_column :places, :longitude, :string
    add_column :places, :locality, :string
    add_column :places, :link, :string
  end
end
