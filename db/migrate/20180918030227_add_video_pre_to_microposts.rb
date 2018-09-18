class AddVideoPreToMicroposts < ActiveRecord::Migration[5.1]
  def change
    add_column :microposts, :video_pre, :string
  end
end
