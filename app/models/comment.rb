class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :image

  validates :user, presence: true
  validates :image, presence: true
  validates :content, presence: true

  scope :load_comment_offset, -> (comment_offset){where("id > ?", comment_offset)}

  def reply_comments
    user_id = self.id
    Comment.where(parent_id: user_id).where.not(id: user_id).order id: :asc
  end

  def reply
    Comment.find_by id: self.reply_id
  end
end
