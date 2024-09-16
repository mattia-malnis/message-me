class AddTokenToProfiles < ActiveRecord::Migration[7.2]
  def change
    add_column :profiles, :token, :string
    add_index :profiles, :token, unique: true
    Profile.reset_column_information
    Profile.find_each(&:regenerate_token)
  end
end
