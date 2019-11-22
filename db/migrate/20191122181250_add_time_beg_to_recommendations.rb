class AddTimeBegToRecommendations < ActiveRecord::Migration[6.0]
  def change
    add_column :recommendations, :time_beg, :date
  end
end
