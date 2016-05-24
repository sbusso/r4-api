class Message
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :content, :type => String
  field :receivers, :type => Array

  belongs_to :user
  belongs_to :room

  validates :content, presence: true
end
