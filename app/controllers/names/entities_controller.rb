module Names
  class EntitiesController < Names::NamesController
    def index
      respond_with(@names = Names::Entity.all)
    end
    def show
      respond_with(@name = Names::Entity.find(params[:id]))
    end
    def new
      respond_with(@name = Names::Entity.new)
    end
    def create
      name = Names::Entity.new
      Name.transaction do
        name = Names::Entity.create(params["names_entity"])
        parent = Names::Entity.where(id: name.parent).first
        DB.create_entity(name.name, parent.name, name.fields)
      end
      respond_with(@name = name)
    end
  end
end
