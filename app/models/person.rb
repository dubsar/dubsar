class Person < ActiveRecord::Base
  belongs_to :subject_ids, :foreign_key => "id"
end
