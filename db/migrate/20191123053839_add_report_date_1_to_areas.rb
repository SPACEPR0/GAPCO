class AddReportDate1ToAreas < ActiveRecord::Migration[6.0]
  def change
    add_column :areas, :report_date_1, :date
  end
end
