class CreateEvaluations < ActiveRecord::Migration[5.2]
  def change
    create_table :evaluations do |t|
      t.integer :user_id
      t.integer :post_id
      t.integer :star_count

      t.timestamps
    end
    add_index :evaluations, :user_id
    add_index :evaluations, :post_id
    add_index :evaluations, [:user_id, :post_id], unique: true
  end
end
