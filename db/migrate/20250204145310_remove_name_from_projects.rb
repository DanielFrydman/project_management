class RemoveNameFromProjects < ActiveRecord::Migration[8.0]
  def change
    remove_column :projects, :name, :string, null: false
  end
end
