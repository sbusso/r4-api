class Message
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :content, :type => String
  belongs_to :user
end
