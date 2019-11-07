class CreateEvidencefiles < ActiveRecord::Migration[6.0]
  def change
    create_table :evidencefiles do |t|

      t.timestamps
    end
  end
end
