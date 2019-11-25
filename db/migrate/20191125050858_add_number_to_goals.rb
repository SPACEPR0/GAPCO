class AddNumberToGoals < ActiveRecord::Migration[6.0]
  def change
    add_column :goals, :number, :integer
  end
end
