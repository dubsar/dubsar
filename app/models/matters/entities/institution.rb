module Matters
  module Entities
    class Institution < Entity
      has_many :emailables, class_name: "Matters::Properties::Emailable", foreign_key: 'entity_id'
      has_many :emails, class_name: "Matters::Things::Email", through: :emailables
      accepts_nested_attributes_for :emails, allow_destroy: true
    end
  end
end
