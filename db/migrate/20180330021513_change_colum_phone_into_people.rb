class ChangeColumPhoneIntoPeople < ActiveRecord::Migration[5.1]
  def up
    change_column :people, :phone, :string
  end

  def down
    change_column :people, :phone, :string
  end
end
