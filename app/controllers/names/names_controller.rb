module Names
  class NamesController < NamesApplicationController
    layout 'home'
    respond_to :html
    def home
    end
    def create_name(klazz)
      name = klazz.new
      Name.transaction do
        name = klazz.create(params["names_thing"])
        parent = klazz.find(name.parent)
        case klazz.name
        when /.*Thing/
          DB.create_thing(name.name, parent.name, name.fields)
        when /.*Entity/
          DB.create_entity(name.name, parent.name, name.fields)
        end
      end
      name
    end
  end
end
