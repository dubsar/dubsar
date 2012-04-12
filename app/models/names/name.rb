require 'active_support/inflector'
module Names
  class Name < Bala
    before_create :check_name
    attr_accessor :parent, :fields
    attr_accessible :name, :parent, :fields
    self.abstract_class = true
    def fields=(_fields)
      @fields = []
      JSON.parse(_fields).each do |f|
        @fields << DB::Field.new(f["name"], f["type"])
      end
    end
    def entity?
      self.class.name == "Names::EntityName"
    end
    def thing?
      self.class.name == "Names::ThingName"
    end
    def matter
      # the name attribute holds the table name
      # of the matter this instance defines
      # this method returns the defined metter's class
      cname = "Matters::"
      cname << "Things" if thing?
      cname << "Entities" if entity?
      cname << "::" << self.name.singularize.camelize
      cname.constantize
    end
    def check_name
      self.name = self.name.tableize
      puts self.name
    end
  end
end
