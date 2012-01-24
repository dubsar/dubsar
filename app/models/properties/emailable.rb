class Emailable < Property
  belongs_to :email, :foreign_key => "thing_id"
  belongs_to :subject, :foreign_key => "subject_id"
end

