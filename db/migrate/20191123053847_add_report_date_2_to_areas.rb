class AddReportDate2ToAreas < ActiveRecord::Migration[6.0]
  def change
    add_column :areas, :report_date_2, :date
  end
end
