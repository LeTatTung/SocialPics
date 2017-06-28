class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  has_many :comments, dependent: :destroy
  has_many :feed_backs, dependent: :destroy
  has_many :images, dependent: :destroy
  has_one :profile, dependent: :destroy
  has_many :active_relationships, class_name: Relationship.name,
    foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: Relationship.name,
    foreign_key: "followed_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  validates_presence_of :email, if: :email_required?
  validates_uniqueness_of :email, allow_blank: true, if: :email_changed?
  validates_format_of :email, with: Devise.email_regexp, allow_blank: true,
    if: :email_changed?
  validates_presence_of :password, if: :password_required?
  validates_confirmation_of :password, if: :password_required?
  validates_length_of :password, within: Devise.password_length,
    allow_blank: true
  validates :name, presence: true

  scope :load_know_users, -> (user_ids){where.not(id: user_ids)
    .order id: :desc}
  scope :load_follow_user, -> (follow_offset){where "id < ?", follow_offset}
  enum sex: [:male, :female]

  mount_uploader :avatar, AvatarUploader

  def just_followed
    following.order(created_at: :desc).limit 10
  end

  def know_users
    user_ids = following.ids
    user_ids.push self.id
    User.load_know_users user_ids
  end

  def images_news_feed
    user_ids = following.ids
    user_ids.push self.id
    Image.load_share_images user_ids
  end

  def likes
    feed_backs.like
  end

  def liked image
    likes.find_by image_id: image.id
  end

  def current_user? user
    self == user
  end

  def update_profile params
    user_params = params[:user_params]
    profile_params = params[:profile_params]
    ActiveRecord::Base.transaction do
      self.update_attributes user_params
      profile = self.profile
      profile.update_attributes(profile_params) if profile_params
    end
    errors = profile.errors
    return errors if errors.any?
    nil
    rescue => e
    return nil
  end
end
