class AddStarCountToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :star_count, :integer, default: 0
  end
end
