module Names
  class Name < Bala
    attr_accessor :parent, :fields
    attr_accessible :name, :parent, :fields
    self.abstract_class = true
    def fields=(_fields)
      @fields ||= []
      JSON.parse(_fields).each do |f|
        @fields << DB::Field.new(f["name"], f["type"])
      end
    end
    def path(plural=false)
      case self.class.name
      when "Names::ThingName"
        p = "thing"
      when "Names::EntityName"
        p = "entity"
      else
        p = "entity"
      end
      plural ? p.pluralize : p
    end
  end
end
