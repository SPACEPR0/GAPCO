class ChangeDescriptionToBeTextInAreas < ActiveRecord::Migration[6.0]
  def change
    change_column :areas, :description, :text
  end
end
