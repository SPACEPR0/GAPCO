class AddAreaIdToRecommendations < ActiveRecord::Migration[6.0]
  def change
    add_reference :recommendations, :area, foreign_key: true
  end
end
