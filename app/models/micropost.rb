class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> {order(created_at:  :desc)}
  mount_uploader :picture,PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true,length: { maximum: 140}
  validate :picture_size
  has_many :comments ,dependent: :destroy
  has_many :dots ,dependent: :destroy

  def isdot(user_id)
    if self.dots.find_by(user_id: user_id).nil?
      return false
    else
      return true
    end
  end

  def dotId(user_id)
    if self.dots.find_by(user_id: user_id).nil?
      return nil
    else
      return self.dots.find_by(user_id: user_id).id
    end
  end
  
  private
  	def picture_size
  		if picture.size > 5.megabytes
  			errors.add(:picture , "should be less than 5MB")
		end
  	end
end
