class AddRecommendationIdToEvidences < ActiveRecord::Migration[6.0]
  def change
    add_reference :evidences, :recommendation, foreign_key: true
  end
end
