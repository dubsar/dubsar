class ResourceController
  def initialize(context, matter)
    @context = context.to_s.camelize
    @matter = matter
  end
  def create
    create_controller
  end
  private
  def create_controller
    return if exists?
    klass = Class.new(Matters::MattersController)
    namespace.const_set(name, klass)
    namespace.const_get(name).class_eval do
      layout 'home'
      def index
        @matters = model_klass.all
        if @matters.length > 0
          respond_with(@matters)
        else
          redirect_to polymorphic_path(model_klass.new, action: :new)
        end
      end
      def edit
        respond_with(@matter = model_klass.find(params[:id]))
      end
      def show
        respond_with(@matter = model_klass.find(params[:id]))
      end
      def new
        respond_with(@matter = model_klass.new)
      end
      def create
        @matter = model_klass.create(find_form)
        respond_with(@matter)
      end
      def update
        @matter = model_klass.find(params[:id])
        @matter.update_attributes(find_form)
        respond_with(@matter)
      end
      def destroy
        @matter = model_klass.find(params[:id])
        @matter.destroy
        respond_with(@matter)
      end
      private
      def model_klass
        model_name = self.class.name.sub(/(.*)(Controller)/, '\1').singularize
        model_name.constantize
      end
      def find_form
        params[params.keys.select {|k| k.start_with?("matters")}.first]
      end
    end
  end
  def exists?
    begin
      eval "#{namespace}.const_get('#{name}')"
    rescue
      return false
    end
    true
  end
  def namespace
    ("Matters::" << @context).constantize
  end
  def name
    @matter.name.pluralize.camelize << "Controller"
  end
end
