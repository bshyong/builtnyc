class CreateCategoriesPlacesTable < ActiveRecord::Migration
  def change
    create_table :categories_places, :id => false do |t|
      t.references :category
      t.references :place
    end
    add_index :categories_places, [:category_id, :place_id]
    add_index :categories_places, :place_id
  end
end
