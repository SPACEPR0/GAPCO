class ChangeNumberToBeStringInRecommendations < ActiveRecord::Migration[6.0]
  def change
    change_column :recommendations, :number, :string
  end
end
