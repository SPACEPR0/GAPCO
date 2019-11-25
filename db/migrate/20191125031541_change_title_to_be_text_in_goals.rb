class ChangeTitleToBeTextInGoals < ActiveRecord::Migration[6.0]
  def change
    change_column :goals, :title, :text
  end
end
