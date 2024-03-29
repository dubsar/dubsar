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
      @name = create_name(Names::Entity)
      respond_with(@name)
    end
  end
end
