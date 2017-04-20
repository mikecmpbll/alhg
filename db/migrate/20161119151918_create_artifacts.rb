class CreateArtifacts < ActiveRecord::Migration[5.0]
  def change
    create_table :artifacts do |t|
      t.string :file
      t.belongs_to :creator, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
