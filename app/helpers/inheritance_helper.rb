module InheritanceHelper
  def names_forest
    forest("names")
  end
  def matters_forest
    forest("matters")
  end
  private
  def forest(context)
    names = []
    Inheritance.matters.each do |tree|
      name = tree.name.singularize.camelize
      klass = eval "Names::#{name}"
      names << tree(Inheritance.send(tree.name), klass, context)
    end
    names
  end
  def tree(tree, klass, context)
    tree.map do |node, childs|
      content_tag(:ul) do
        name = klass.where(name: node.name).first
        url = url(node, name, context)
        path = link_to(name.name.humanize, url)
        content_tag(:li) do
          path + tree(childs, klass, context)
        end
      end
    end.join.html_safe
  end
  def url(node, name, context)
    case context
    when "names"
      names_url(node, name)
    when "matters"
      matters_url(name)
    end
  end
  def names_url(node, name)
    if node.is_root?
      polymorphic_path(name.class)
    else
      polymorphic_path(name)
    end
  end
  def matters_url(name)
    polymorphic_path(name.matter)
  end
end

