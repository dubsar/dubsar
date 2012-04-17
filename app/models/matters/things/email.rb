module Matters
  module Things
    class Email < Thing
      has_many :emailables, class_name: "Matters::Properties::Emailable", foreign_key: 'thing_id'
      def to_s
        email
      end
      def self.create(attributes = nil, options = {}, &block)
        create!(attributes, options, &block)
      end
    end
  end
end
