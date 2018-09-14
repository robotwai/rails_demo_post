class AddIndexToMicropostsVideo < ActiveRecord::Migration[5.1]
  def change
  	add_column :microposts, :video, :string
  end
end
