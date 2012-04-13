class Resource
  def initialize(namespace, matter)
    @namespace = namespace.to_s.camelize
    @matter = matter
  end
  def create
    create_matter(@matter)
  end
  private
  def create_matter(matter)
    return if exists?(matter)
    create(matter.parent) if matter.parent unless exists?(matter.parent)
    klass_name = name(matter.name)
    parent_klass_name = matter.parent ? name(matter.parent.name) : "Bala"
    klass = Class.new("#{namespace}::#{parent_klass_name}".constantize)
    namespace.constantize.const_set(klass_name, klass)
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
    klass.singularize.camelize
  end

end
