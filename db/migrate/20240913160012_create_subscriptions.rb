class CreateSubscriptions < ActiveRecord::Migration[7.2]
  def change
    create_table :subscriptions do |t|
      t.belongs_to :profile
      t.text :endpoint, null: false
      t.text :p256dh_key, null: false
      t.text :auth_key, null: false
      t.timestamps
    end

    add_index :subscriptions, :endpoint, unique: true
  end
end
