class AddIndexToUsersSignContent < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :sign_content, :string
    add_column :users, :sex, :integer
  end
end
