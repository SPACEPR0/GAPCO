class AddUserEmailToAreas < ActiveRecord::Migration[6.0]
  def change
    add_reference :areas, :user, null: true #Quizás luego lo hagamos false cuando el coordinador agregue users
  end
end
