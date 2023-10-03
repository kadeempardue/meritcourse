class AddPdfToLessons < ActiveRecord::Migration[5.1]
  def change
    add_column :lessons, :pdf_url, :text
  end
end
