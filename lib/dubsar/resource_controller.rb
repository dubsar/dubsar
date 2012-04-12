class ResourceController
  def initialize(namespace, matter)
    @namespace = namespace.to_s.camelize
    @matter = matter
  end
  def create
    create_controller(@matter)
  end
  private
  def create_controller(matter)
    #puts matter
    return if exists?(matter)
    klass_name = name(matter.name)
    klass = Class.new(Matters::MattersController)
    namespace.constantize.const_set(klass_name, klass)
    model_klass_name = model_name(matter.name)
    model_klass = "#{namespace}::#{model_klass_name}".constantize
    namespace.constantize.const_get(klass_name).class_eval do
      layout 'home'
      def index
        respond_with(@matter = model_klass.all)
      end
      def show
        respond_with(@matter = model_klass.where(id: params[:id]))
      end
      def new
        respond_with(@matter = model_klass.new)
      end
      def create
        @matter = model_klass.create(find)
        respond_with(@matter)
      end
      private
      def model_klass
        name = self.class.name.gsub(/(.*)(Controller)/, '\1').singularize
        name.constantize
      end
      def find
        params.map {|k,v| v if k.start_with("matters")}.first
      end
    end
  end
  def exists?(matter)
    name = name(matter.name)
    begin
      eval "#{namespace}.const_get('#{name}')"
    rescue
      return false
    end
    true
  end
  def namespace
    "Matters::" << @namespace
  end
  def name(klass)
    klass.camelize << "Controller"
  end
  def model_name(klass)
    klass.singularize.camelize
  end
end
