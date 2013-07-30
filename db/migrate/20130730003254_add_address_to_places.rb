class AddAddressToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :address, :string
    add_column :places, :zipcode, :string
    add_column :places, :city, :string
    add_column :places, :state, :string
  end
end
