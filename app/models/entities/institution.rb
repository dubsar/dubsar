class Institution < Entity
  has_many :emailables, :foreign_key => 'entity_id'
  has_many :emails, :through => :emailables
  accepts_nested_attributes_for :emails, :allow_destroy => true
end
