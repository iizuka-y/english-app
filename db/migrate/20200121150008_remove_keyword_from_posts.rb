class RemoveKeywordFromPosts < ActiveRecord::Migration[5.2]
  def change
    remove_column :posts, :keyword, :string
  end
end
