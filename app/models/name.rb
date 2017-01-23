class Name
  include DataMapper::Resource

  property :id, Serial
  property :value, String

  belongs_to :player
end
