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
        url = get_url(node.name, name)
        path = link_to(name.name, url)
        content_tag(:li) do
          path + nested_hierarchy_runner(childs, _clazz, _name)
        end
      end
    end.join.html_safe
  end
  def get_url(node_name, name)
    if %w(things entities).include?(node_name)
      url = names_path(name, "index")
    else
      url = names_path(name, "show")
    end
    url
  end
end
