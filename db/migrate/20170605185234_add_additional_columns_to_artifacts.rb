class AddAdditionalColumnsToArtifacts < ActiveRecord::Migration[5.0]
  def change
    add_column :artifacts, :description, :text
    add_column :artifacts, :filename, :string
  end
end
