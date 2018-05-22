class CreateDots < ActiveRecord::Migration[5.1]
  def change
    create_table :dots do |t|
      t.integer :user_id
      t.integer :micropost_id

      t.timestamps
    end
    add_index :dots ,:user_id
    add_index :dots ,:micropost_id
    add_index :dots, [:user_id,:micropost_id],unique: true
  end
end
