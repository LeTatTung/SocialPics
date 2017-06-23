class Image < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :user, presence: true
  validates :category, presence: true

  mount_uploader :image, ImageUploader

  scope :popular_images, -> {order(like_number: :desc).limit Settings.limit_popular_images}
  scope :load_share_images, -> (user_ids){where('user_id in (?) or share_id in (?)',
  	user_ids, user_ids)}
  scope :load_image_offset, -> (image_offset){where("id > ?", image_offset)}
end
