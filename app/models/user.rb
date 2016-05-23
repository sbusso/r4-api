class User 
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :email, :type => String
  field :password, :type => String
  field :token, :type => String

  validates :email, :password, presence: true
  validates :email, uniqueness: true
end
