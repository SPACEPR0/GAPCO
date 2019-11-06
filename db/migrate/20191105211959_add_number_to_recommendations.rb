class AddNumberToRecommendations < ActiveRecord::Migration[6.0]
  def change
    add_column :recommendations, :number, :integer
  end
end
