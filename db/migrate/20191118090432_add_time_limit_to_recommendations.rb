class AddTimeLimitToRecommendations < ActiveRecord::Migration[6.0]
  def change
    add_column :recommendations, :time_limit, :date
  end
end
