class CreateMessages < ActiveRecord::Migration[7.2]
  def change
    create_table :messages do |t|
      t.text :content, null: false
      t.belongs_to :profile
      t.belongs_to :chat

      t.timestamps
    end
  end
end
