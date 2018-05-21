class ChangeComment < ActiveRecord::Migration[5.1]
  def change
  	change_table :comments do |t|
	  t.remove :commenter
	  t.integer :commenter_id
	end
	 add_index :comments ,:commenter_id
  end
end
