module Names
  class ThingNamesController < NamesController
    respond_to :html
    def index
      respond_with(@names = Names::ThingName.all.reject {|n| n.name == "things"})
    end
    def show
      respond_with(@name = Names::ThingName.find(params[:id]))
    end
    def new
      respond_with(@name = Names::ThingName.new)
    end
    def create
      name = Names::ThingName.new
      Name.transaction do
        name = Names::ThingName.create(params["names_thing_name"])
        puts name.inspect
        parent = Names::ThingName.where(id: name.parent).first
        DB.create_thing(name.name, parent.name, name.fields)
      end
      respond_with(@name = name, :location => names_thing_path(name))
    end
  end
end
