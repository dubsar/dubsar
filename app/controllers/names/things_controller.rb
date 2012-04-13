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
      name = Names::Thing.new
      Name.transaction do
        name = Names::Thing.create(params["names_thing"])
        puts name.fields.inspect
        parent = Names::Thing.where(id: name.parent).first
        DB.create_thing(name.name, parent.name, name.fields)
      end
      respond_with(@name = name)
    end
  end
end
