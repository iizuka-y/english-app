class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :evaluations, dependent: :destroy
  has_many :comments, dependent: :destroy

  attr_accessor :remember_token
  before_save { self.email = email.downcase } #DB保存前に文字を全て小文字にする
  validates :name,  presence: true, length: { maximum: 20 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i #emailの正規表現
  validates :email, presence: true, length: { maximum: 100 },format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false } #uniqueness～を使用することで同じemailを登録できなくする
  has_secure_password
  validates :password, presence: true, length: { minimum: 4 }, allow_nil: true

  # 渡された文字列のハッシュ値を返す(ダイジェストに変換)
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  #ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  #永続セッションのためにユーザーをデーターベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 引数として受け取った値を記憶トークンに代入して暗号化（記憶ダイジェスト）し、DBにいるユーザーの記憶ダイジェストと比較、同一ならtrueを返す
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # 現在のログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end

  # user_idの投稿を取得
  def feed
    Post.where("user_id = ?", id)
  end

end
