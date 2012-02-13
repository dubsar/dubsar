class Subject < ActiveRecord::Base
  set_table_name "subject_types"
  def self.grouped
    count(:all, :group => 'relname')
  end
end
