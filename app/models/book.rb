class Book < ApplicationRecord

  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true, length:{maximum:200}
  validates :category, presence: true


  scope :latest, -> {order(created_at: :desc)}
  scope :old, -> {order(created_at: :asc)}
  scope :star_count, -> {order(star: :desc)}


  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end


  def self.search_for(word, method)
    if method == 'perfect'
      Book.where(title: word)
    elsif method == 'forward'
      Book.where('title LIKE ?', word + '%' )
    elsif method == 'backward'
      Book.where('title LIKE ?', '%' + word )
    else
      Book.where('title LIKE ?', '%' + word + '%' )
    end
  end


end
