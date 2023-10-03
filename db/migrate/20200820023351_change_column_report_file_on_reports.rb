class ChangeColumnReportFileOnReports < ActiveRecord::Migration[5.1]
  def change
    remove_column :reports, :report_file
  end
end
