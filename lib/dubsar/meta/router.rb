class Router
  class << self
    def matters(router)
      @@router = router
      matters = Inheritance.matters
      matters.each do |matter|
        @@namespace = matter.name.to_sym
        each matter
      end
    end
    def reload
       Dubsar::Application.reload_routes!
    end
    private
    def each(matter)
      create_model matter
      create_controller matter
      create_route matter.name
      matter.children.each do |child|
        each child
      end
    end
    def create_route(resource)
      @@router.instance_eval do
        namespace :matters do
          namespace @@namespace do
            resources resource.to_sym
          end
        end
      end
    end
    def create_model(resource)
      model = Resource.new(@@namespace, resource)
      model.create
    end
    def create_controller(resource)
      controller = ResourceController.new(@@namespace, resource)
      controller.create
    end
  end
end
