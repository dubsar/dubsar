ActiveAdmin.register Email do
  menu :parent => "Things"
  controller do
    def create
      @email = Email.where(:email => params[:email][:email]).first_or_create!
      if @emailable = find_emailable
        @emailable.emails << @email
        @emailable.save
      end
      respond_to do |format|
        format.js { render :nothing => true }
      end
    end
    private
    def find_emailable
      params.each do |name, value|
        if name =~ /(.+)_id$/
          return $1.classify.constantize.find(value)
        end
      end
      nil
    end
  end
end
