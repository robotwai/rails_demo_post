class CreatePeople < ActiveRecord::Migration[5.1]
  def change
  	# drop_table :people

    create_table :people do |t|
      t.string :name
      t.string :address
      t.string :phone

      t.timestamps
    end
  end
end
