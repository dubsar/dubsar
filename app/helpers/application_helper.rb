module ApplicationHelper
  def selected_tab(_tab)
    selected = false
    case _tab
    when "home"
      selected = current_page? :controller => "home", :action => "index"
    when "search"
      selected = 
        current_page?(:controller => "home", :action => "search") ||
        current_page?(:controller => "home", :action => "find") ||
        current_page?(:controller => "home", :action => "view") ||
        current_page?(:controller => "home", :action => "play") ||
        current_page?(:controller => "home", :action => "read")
    when "login"
      selected = current_page? :controller => "sessions", :action => "new"
    when "names"
      selected = controller.class.name.start_with? "Names"
    end
    return selected ? "selected" : ""
  end
end
