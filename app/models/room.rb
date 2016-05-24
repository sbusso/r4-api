class Room
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :receivers, :type => Array

  has_many :messages
end
