class ChangeName < ActiveRecord::Migration[5.1]
  def up
    rename_column :comments, :commenter_id, :user_id
  end

  def down
    rename_column :comments, :user_id, :commenter_id
  end
end
