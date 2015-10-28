class Video < ActiveRecord::Base
  include Tokenable

  belongs_to :category
  belongs_to :user
  has_many :reviews, -> { order 'created_at DESC' }
  validates_presence_of :title, :description

  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    where("title LIKE ?", "%#{search_term}%").order("created_at DESC")
  end

  def to_param
    token
  end
end
