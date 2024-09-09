class CreateProfiles < ActiveRecord::Migration[7.2]
  def change
    create_table :profiles do |t|
      t.string :name, null: false
      t.string :nickname, null: false
      t.string :bio
      t.belongs_to :user, null: false

      t.timestamps
    end

    add_index :profiles, "lower(nickname)", unique: true
  end
end
