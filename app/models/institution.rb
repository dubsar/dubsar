class Institution < Activerecord::Base
  belongs_to :subject_ids, :foreign_key => "id"
end

