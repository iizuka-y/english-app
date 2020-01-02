class CreateMutes < ActiveRecord::Migration[5.2]
  def change
    create_table :mutes do |t|
      t.integer :muting_id
      t.integer :muted_id

      t.timestamps
    end
    add_index :mutes, :muting_id
    add_index :mutes, :muted_id
    add_index :mutes, [:muting_id, :muted_id], unique: true
  end
end
