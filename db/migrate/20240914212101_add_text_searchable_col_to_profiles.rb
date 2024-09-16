class AddTextSearchableColToProfiles < ActiveRecord::Migration[7.2]
  def change
    add_column :profiles, :textsearchable_col, :virtual, type: :tsvector,
               as: "to_tsvector('english', coalesce(name, '') || ' ' || coalesce(nickname, '') || ' ' || coalesce('@' || nickname, ''))",
               stored: true
    add_index :profiles, :textsearchable_col, using: :gin
  end
end
