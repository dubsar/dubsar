module Matters
  module Properties
    class Emailable < Property
      belongs_to :email, class_name: "Matters::Things::Email", foreign_key: 'thing_id'
      belongs_to :person, class_name: "Matters::Entities::Person", foreign_key: 'entity_id'
      belongs_to :institution, class_name: "Matters::Entities::Institution", foreign_key: 'entity_id'
    end
  end
end
