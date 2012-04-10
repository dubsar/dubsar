module Names
  class EntityNamesController < Names::NamesController
    def index
      respond_with(@names = Names::EntityName.all)
    end
    def show
      respond_with(@name = Names::EntityName.find(params[:id]))
    end
    def new
      respond_with(@name = Names::EntityName.new)
    end
    def create
      name = Names::EntityName.new
      Name.transaction do
        name = Names::EntityName.create(params["names_entity_name"])
        parent = Names::EntityName.where(id: name.parent).first
        DB.create_entity(name.name, parent.name, name.fields)
      end
      respond_with(@name = name, :location => names_entity_path(name))
    end
  end
end
