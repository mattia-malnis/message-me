class CreateChats < ActiveRecord::Migration[7.2]
  def change
    create_table :chats do |t|
      t.string :token, null: false

      t.timestamps
    end

    add_index :chats, :token, unique: true
  end
end
