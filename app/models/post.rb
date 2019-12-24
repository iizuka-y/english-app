class Post < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) } # 新しい投稿順に取得する
  validates :user_id, presence: true
  validates :keyword, presence: true, length: { maximum: 50 }
  validates :content, presence: true, length: { maximum: 200 }

end
