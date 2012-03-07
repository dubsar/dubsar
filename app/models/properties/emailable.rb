class Emailable < Property
  belongs_to :email, :foreign_key => 'thing_id'
  belongs_to :person, :foreign_key => 'entity_id'
  belongs_to :institution, :foreign_key => 'entity_id'
end

