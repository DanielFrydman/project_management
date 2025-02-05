class CreateStatusChanges < ActiveRecord::Migration[8.0]
  def change
    create_table :status_changes do |t|
      t.references :project, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :old_status, null: false
      t.string :new_status, null: false

      t.timestamps

      t.index [ :project_id, :created_at ]
    end
  end
end
