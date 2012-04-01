class RoutesController < ApplicationController
  respond_to :html
  def resolve
    route = params[:route]
    begin
      find route
    rescue Exception => e
      #should be a redirect
      #redirect_to root_url
      #raise "Invalid resource #{route}"
      raise e
    end
  end
  def find(_name)
   rf = ResourceFactory.new(_name)
  end
  class ResourceFactory
    def self.loaded?(_name)
      Object.const_get(_name.singularize.camelize) ? true : false
    end
    def self.defined?(_name)
      Inheritance.where(:name => _name.tableize).size == 1
    end

    def initialize(_name)
      # _name is supposed to be in the routes form, eg: roles for Role and RolesController
      @name = _name
      raise unless ResourceFactory.defined? @name
      @resource = Resource.new(@name)
    end
    def model
      @resource.model
    end
    def controller
      @resource.controller
    end
    def route
      @resource.route
    end

    class Resource
      attr_reader :model, :controller, :route
      def initialize(_name)
        @model = Model.new(_name)
        @controller = Controller.new(_name)
        @route = Route.new(_name)
      end
      class Model
        def initialize(_name)
          @name = _name
          @parent = get_parent
          create
        end
        def name
          @name.singularize.camelize
        end
        def table_name
          @name.tableize
        end
        def clazz
          Object.const_get(self.name)
        end
        private
        def create
          return if self.clazz
          c = Class.new(@parent.clazz)
          Object.const_set self.name, c
          Object.const_get(self.name).instance_eval do
            set_table_name self.table_name
          end
        end
        def get_parent
          p = Inheritance.where(:name => self.table_name).first.parent
          p ? Model.new(p.name) : BalaModel.new
        end
        #we actually should never get here
        class BalaModel < Model
          def initialize
          end
          def clazz
            Bala
          end
        end
      end
      class Controller
        def initialize(_name)
          @name = _name
          create
        end
        def name
          "#{@name}_controller".camelize
        end
        private
        def create
          Object.const_set self.name.intern, Class.new(ResourceController)
          Object.const_get(self.name).instance_eval do
            layout 'home'
            inherit_resources
          end
        end
      end
      class Route
        def initialize(_name)
          @name = _name
          create
        end
        def name
          @name.pluralize.to_sym
        end
        private
        def create
          begin
            routes = Dubsar::Application.routes
            routes.disable_clear_and_finalize = true
            routes.clear!
            route_name = name
            #prepend to avoid the catch all route
            routes.draw do
              resources route_name
            end
            #append static routes
            Dubsar::Application.routes_reloader.paths.each{ |path| load(path) }
            ActiveSupport.on_load(:action_controller) { routes.finalize! }
          ensure
            routes.disable_clear_and_finalize = false
          end
        end
      end
    end
  end
end

