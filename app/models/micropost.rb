#!/usr/bin/ruby
class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> {order(created_at:  :desc)}
  mount_uploaders :picture,PictureUploader
  mount_uploader :video, VideouploaderUploader
  serialize :picture, JSON # If you use SQLite, add this line.
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
      return 0
    else
      return self.dots.find_by(user_id: user_id).id
    end
  end

  def video_pre_url
    if self.video.url!=nil
      String x =self.video.url
      String c = x.slice(0,x.rindex("/"))
      String b= x.slice(x.rindex("/"),x.length)

      String @url = b.slice(1,b.rindex("."))
      @url = c+"/thumb_"+@url+"jpeg"
      # a = self.video.url.str[0,5]
      # @url =self.video.url
      return @url
  
    else
      return ""
    end

    
  end
  
  private
  	def picture_size
  		if picture.size > 5.megabytes
  			errors.add(:picture , "should be less than 5MB")
		end
  	end
end
