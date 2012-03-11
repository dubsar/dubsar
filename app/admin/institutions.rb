ActiveAdmin.register Institution do
  # TODO
  #controller.authorize_resource
  menu :parent => "Entities"
  index do
    column :name do |p|
      link_to p.name, [:admin, p]
    end
    column "Email" do |p|
      (p.emails.map{ |e| e.email }).join(' ')
    end
    default_actions
  end
  form do |f|
    f.inputs do
      f.input :name, :as => :string
    end
    f.buttons
  end
  sidebar "Emails", :only => [:edit, :show] do
    render :partial => "emails", :locals => { :parent => institution }
  end
end
