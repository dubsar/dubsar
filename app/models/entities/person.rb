class Person < Entity
  has_many :emailables, :foreign_key => 'entity_id'
  has_many :emails, :through => :emailables, :dependent => :delete_all
  accepts_nested_attributes_for :emails
end
