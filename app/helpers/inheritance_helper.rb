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
    html = "<ul>" << names.join << "</ul>"
    html.html_safe
  end
  def tree(tree, klass, context, html="")
    tree.map do |node, children|
      name = klass.where(name: node.name).first
      url = url(node, name, context)
      path = link_to(name.name.humanize, url)
      html << "<li>" << path
      html << "<ul>" unless children.empty?
      tree(children, klass, context, html)
      html << "</ul>" unless children.empty?
      html << "</li>"
    end
    html
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

