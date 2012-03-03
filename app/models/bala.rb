class Bala < ActiveRecord::Base
  self.abstract_class = true
  attr_reader :content
  searchable do
    text :content, :as => 'content'
  end
end

