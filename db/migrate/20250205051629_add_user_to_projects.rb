class AddUserToProjects < ActiveRecord::Migration[8.0]
  def up
    # First add the column as nullable
    add_reference :projects, :user, null: true, foreign_key: true, index: true

    # Assign existing projects to the first user
    if (user = User.first)
      Project.update_all(user_id: user.id)
    else
      # If no user exists, create a system user
      user = User.create!(
        email: 'system@example.com',
        password: SecureRandom.hex(10),
        name: 'System'
      )
      Project.update_all(user_id: user.id)
    end

    # Now make the column non-nullable
    change_column_null :projects, :user_id, false
  end

  def down
    remove_reference :projects, :user
  end
end
