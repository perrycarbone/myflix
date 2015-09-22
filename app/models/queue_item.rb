class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates_numericality_of :position, {only_integer: true}

  def video_title
    video.title
  end

  def rating
    review = Review.find_by(user_id: user.id, video_id: video.id)
    review.rating if review
  end

  def category_name
    video.category.name
  end

  def category
    video.category
  end
end
