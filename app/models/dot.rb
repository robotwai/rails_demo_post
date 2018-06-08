class Dot < ApplicationRecord
	belongs_to :micropost
	belongs_to :user
	validates :user_id,presence: true
	validates :micropost_id,presence: true

end
