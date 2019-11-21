class AddUsersNoToAlerts < ActiveRecord::Migration[6.0]
  def change
    add_column :alerts, :usersNO, :text
  end
end
