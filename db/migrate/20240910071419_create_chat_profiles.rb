class CreateChatProfiles < ActiveRecord::Migration[7.2]
  def change
    create_table :chat_profiles do |t|
      t.belongs_to :chat
      t.belongs_to :profile
      t.timestamps
    end

    # each user appears in a chat only once
    add_index :chat_profiles, [:chat_id, :profile_id], unique: true
  end
end
