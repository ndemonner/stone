class Comment #:nodoc:
  include Stone::Resource
  
  field :body, String

  belongs_to :post
  belongs_to :person
  belongs_to :author
end