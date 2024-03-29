module ApplicationHelper
  def selected_tab(_tab)
    selected = false
    case _tab
    when "home"
      return "" unless controller.class.name.start_with? "Home"
      selected = current_page? :controller => "home", :action => "index"
    when "search"
      return "" unless controller.class.name.start_with? "Home"
      selected = 
        current_page?(:controller => "home", :action => "search") ||
        current_page?(:controller => "home", :action => "find") ||
        current_page?(:controller => "home", :action => "view") ||
        current_page?(:controller => "home", :action => "play") ||
        current_page?(:controller => "home", :action => "read")
    when "login"
      return "" unless controller.class.name.start_with? "Session"
      selected = current_page? :controller => "sessions", :action => "new"
    when "names"
      selected = controller.class.name.start_with? "Names"
    when "matters"
      selected = controller.class.name.start_with? "Matters"
    end
    return selected ? "selected" : ""
  end
  #def names_path(name, action)
  #  p = %w(new edit).include?(action) ? "#{action}_names_" : "names_"
  #  p << "thing" if name.thing?
  #  p << "entity" if name.entity?
  #  p = %w(index create).include?(action) ? p.pluralize : p
  #  p << "_path"
  #  case action
  #  when "edit", "show"
  #    p = "#{p}(name)"
  #  when "new"
  #    p = "#{p}(name.class.new)"
  #  else
  #    p = "#{p}"
  #  end
  #  eval p
  #end
end
