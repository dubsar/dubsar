class Bala < ActiveRecord::Base
  set_table_name do
    self.name.split("::").last.tableize
  end
  self.abstract_class = true
  attr_reader :content
  searchable do
    text :content, :as => 'content'
  end
end

