class AddUserEmailToAreas < ActiveRecord::Migration[6.0]
  def change
    add_reference :areas, :user
  end
end
