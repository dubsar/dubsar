module Names
  class ThingsController < NamesController
    respond_to :html
    def index
      respond_with(@names = Names::Thing.all.reject {|n| n.name == "things"})
    end
    def show
      respond_with(@name = Names::Thing.find(params[:id]))
    end
    def new
      respond_with(@name = Names::Thing.new)
    end
    def create
      @name = create_name(Names::Thing)
      respond_with(@name)
    end
  end
end
