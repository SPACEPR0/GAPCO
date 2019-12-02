class AddActionToEvidences < ActiveRecord::Migration[6.0]
  def change
    add_column :evidences, :action, :string
  end
end
