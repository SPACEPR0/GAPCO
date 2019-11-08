class CreateGoals < ActiveRecord::Migration[6.0]
  def change
    create_table :goals do |t|
      t.string :title
      t.text :actions
      t.references :recommendation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
