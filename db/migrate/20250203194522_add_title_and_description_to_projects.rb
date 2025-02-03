class AddTitleAndDescriptionToProjects < ActiveRecord::Migration[8.0]
  def change
    add_column :projects, :title, :string, null: false
    add_column :projects, :description, :text

    add_index :projects, :title
  end
end
