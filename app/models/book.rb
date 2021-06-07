class Book < ApplicationRecord
	
    is_impressionable
	
	belongs_to :user
	has_many :favorites, dependent: :destroy
	has_many :comments,  dependent: :destroy
	has_many :favorite_users, through: :favorites, source: :user

	def favorited_by?(user)
		favorites.where(user_id: user.id).exists?
	end

	validates :title, presence: true
	validates :body, presence: true, length: {maximum: 200}

	# 検索機能のlooksメソッド定義
	def self.looks(search,word)
		if search == 'perfect_match'
			@book = Book.where('title LIKE?', "#{word}")
		elsif search == 'forword_match'
			@book = Book.where('title LIKE?', "#{word}%")
		elsif search == 'backword_match'
			@book = Book.where('title LIKE?', "%#{word}")
		elsif search == 'partial_match'
			@book = Book.where('title LIKE?', "%#{word}%")
		else
			@book = Book.all
		end
	end
	
	#本のカテゴリ検索
  def self.book_search(search_word)
    Book.where(['category LIKE ?', "%#{search_word}%"])
  end
	
	# 日毎の投稿数スコープを作成取得する
	scope :created_today, -> {where(created_at: Time.zone.now.all_day)}
	scope :created_yesterday, -> {where(created_at: 1.day.ago.all_day)}
	scope :created_2day_ago, -> {where(created_at: 2.day.ago.all_day)}
	scope :created_3day_ago, -> {where(created_at: 3.day.ago.all_day)}
	scope :created_4day_ago, -> {where(created_at: 4.day.ago.all_day)}
	scope :created_5day_ago, -> {where(created_at: 5.day.ago.all_day)}
	scope :created_6day_ago, -> {where(created_at: 6.day.ago.all_day)}
end
