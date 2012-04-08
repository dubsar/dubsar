module InheritanceHelper
  def nested_hierarchy(_name, _hierarchy)
    name = _name.singularize.camelize
    clazz = eval "Names::#{name}Name"
    nested_hierarchy_runner(_hierarchy, clazz, _name)
  end
  private
  def nested_hierarchy_runner(_hierarchy, _clazz, _name)
    _hierarchy.map do |node, childs|
      content_tag(:ul, :class => "nested_hierarchies") do
        name = _clazz.where(name: node.name).first
        url = (eval "names_#{name.path}_path(name)")
        path = link_to(name.name, url)
        content_tag(:li) do
          path + nested_hierarchy_runner(childs, _clazz, _name)
        end
      end
    end.join.html_safe
  end
end
