class CreateAlerts < ActiveRecord::Migration[6.0]
  def change
    create_table :alerts do |t|
      t.text :content
      t.date :expiration

      t.timestamps
    end
  end
end
