class CreateGuests < ActiveRecord::Migration[6.1]
  def change
    create_table :guests do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.text :phone_numbers, array:true, default: []
      t.timestamps
    end
    add_index :guests, :email # set column email as index beacuse it will be uniq
  end
end
