ActiveAdmin.register Person do
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
    f.inputs "Emails" do
      f.has_many :emails do |e|
        e.input :email, :as => :string
      end
    end
    f.buttons
  end
end
