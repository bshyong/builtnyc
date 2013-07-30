class CreateFirms < ActiveRecord::Migration
  def change
    create_table :firms do |t|
      t.string :name
      t.string :url
      t.text :principals
      t.string :address
      t.string :zipcode
      t.string :city
      t.string :state

      t.timestamps
    end
  end
end
