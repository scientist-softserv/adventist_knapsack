class AddFileNameToUploadedFiles < ActiveRecord::Migration[6.1]
  def change
    add_column :uploaded_files, :filename, :string
  end
end
