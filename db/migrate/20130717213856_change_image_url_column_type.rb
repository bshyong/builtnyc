class ChangeImageUrlColumnType < ActiveRecord::Migration
  def self.up
    change_column :places, :image_url, :text
  end

  def self.down
    change_column :places, :image_url, :string
  end
end
