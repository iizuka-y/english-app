class AddStarCountAndSelfIntroductionToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :star_count, :integer, default: 0
    add_column :users, :self_introduction, :text
  end
end
