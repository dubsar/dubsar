class SubjectId < ActiveRecord::Base
  has_many :people
  has_many :institutions
end
