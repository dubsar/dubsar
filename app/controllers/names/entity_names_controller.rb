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
  end
end
