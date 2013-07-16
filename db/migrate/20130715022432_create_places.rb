class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.text :summary
      t.string :year_built
      t.string :image_url
      t.string :arch_style
      t.string :gov_body
      t.string :nhrp_ref

      t.timestamps
    end
  end
end
