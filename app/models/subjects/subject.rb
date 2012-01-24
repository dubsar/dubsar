class Subject < ActiveRecord::Base
  self.abstract_class = true
  attr_accessible :email_tokens
  attr_reader :email_tokens
  has_many :emailables
  has_many :emails, :through => :emailables

  def email_tokens=(ids)
    self.email_ids = ids.split(",")
  end
  def properties()
    associations = []
    self.class.reflect_on_all_associations.each do |a|
      pclazz = a.plural_name.singularize.camelize.constantize
      associations << pclazz if pclazz < Thing
    end
    associations
  end
end
