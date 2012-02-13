ActiveRecord::Schema.define(:version => 20120113150051) do
  create_table "subject_ids", :force => true do |t|
  end
  create_table "subjects", :id => false, :force => true do |t|
    t.integer "id",   :null => false
  end
  create_table "people", :id => false, :force => true do |t|
    t.integer "id",   :null => false
    t.string "name"
  end
end
