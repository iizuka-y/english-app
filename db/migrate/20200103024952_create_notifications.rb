class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.integer :notified_by_id
      t.integer :post_id
      t.integer :evaluation_id
      t.integer :comment_id
      t.boolean :read
      t.string :notified_type

      t.timestamps
    end
    add_index :notifications, :user_id
    add_index :notifications, :notified_by_id
    add_index :notifications, :evaluation_id
    add_index :notifications, :comment_id
  end
end
