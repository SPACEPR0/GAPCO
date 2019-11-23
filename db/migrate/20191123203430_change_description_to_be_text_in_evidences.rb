class ChangeDescriptionToBeTextInEvidences < ActiveRecord::Migration[6.0]
  def change
    change_column :evidences, :description, :text
  end
end
