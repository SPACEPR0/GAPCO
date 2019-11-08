class AddDayToEvidences < ActiveRecord::Migration[6.0]
  def change
    add_column :evidences, :day, :date
  end
end
