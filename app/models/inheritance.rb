class Inheritance < ActiveRecord::Base
  set_primary_key :id
  has_ancestry
end
