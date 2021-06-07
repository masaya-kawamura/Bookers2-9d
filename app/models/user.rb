class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books,     dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :comments,  dependent: :destroy
  has_many :active_relationships, class_name: 'Relationship',
                                 foreign_key: 'follower_id',
                                   dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :passive_relationships, class_name: 'Relationship',
                                  foreign_key: 'followed_id',
                                    dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  has_many :user_rooms, dependent: :destroy
  has_many :chats, dependent: :destroy
  
  has_many :group_users
  has_many :groups, through: :group_users  

  attachment :profile_image

  validates :name, presence: true, length: {maximum: 20, minimum: 2}, uniqueness: true
  validates :introduction, length: {maximum: 50}
  validates :postcode, format: { with: /\d{7}/ }, presence: true
  validates :prefecture_code, presence: true
  validates :address_city, presence: true
  validates :address_street, presence: true

  # ユーザーをフォローするメソッド
  def follow(other_user)
    following << other_user
  end

  # ユーザーのフォロー解除
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 現在のユーザーをフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end

  # 検索機能のlooksメソッド定義
  def self.looks(search, word)
    if search == "perfect_match"
      @user = User.where('name LIKE?', "#{word}")
    elsif search == "forward_match"
      @user = User.where('name LIKE?', "#{word}%")
    elsif search == 'backword_match'
      @user = User.where('name LIKE?', "%#{word}")
    elsif search == 'partial_match'
      @user = User.where('name LIKE?', "%#{word}%")
    else
      @user = User.all
    end
  end

  include JpPrefecture
  jp_prefecture :prefecture_code

  def prefecture_name
    JpPrefecture::Prefecture.find(code: prefecture_code).try(:name)
  end

  def prefecture_name=(prefecture_name)
    self.prefecture_code = JpPrefecture::Prefecture.find(name: prefecture_name).code
  end

end
