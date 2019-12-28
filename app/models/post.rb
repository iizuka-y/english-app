class Post < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) } # 新しい投稿順に取得する
  mount_uploader :image, ImageUploader
  validates :user_id, presence: true
  validates :keyword, presence: true, length: { maximum: 50 }
  validates :content, presence: true, length: { maximum: 200 }
  validate :image_size

  private
    def image_size
      if image.size > 5.megabytes
        errors.add(:image, "5MB以上の画像は投稿できません")
      end
    end

end
