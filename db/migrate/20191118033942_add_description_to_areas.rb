class AddDescriptionToAreas < ActiveRecord::Migration[6.0]
  def change
    add_column :areas, :description, :string
  end
end
