class Search < ActiveRecord::Base
  def self.to_tsquery(_q)
    return unless _q.class == String
    # "a b" -> "a & b
    _q.strip.gsub /\s+/, " & "
  end
  def self.query(q)
    q = to_tsquery(q)
    where("content @@ to_tsquery(?)", q) 
  end
  def self.cloud(_limit=40)
    cloud = ActiveRecord::Base.connection.exec_query "select * from tags limit(#{_limit})"
    #cloud.to_json
  end

  def self.count_items_per_relation(_query)
    count = {}
    select("item_relation, count(item_relation) as relation_count").
      where("((content) @@ (to_tsquery(?)))", _query).
      group(:item_relation).
      each do |item|
      count[item.item_relation] = item.relation_count
      end
    count
  end
  def self.items_per_relation(_query, _relation)
    ids = []
    select("item_id").
      where("((content) @@ (to_tsquery(?))) AND (item_relation = ?)", _query, _relation).
      each do |record|
      ids << record.item_id
      end
    ids
  end
  def self.relations_per_query(_query)
    relations = []
    select("distinct item_relation").
      where("((content) @@ (to_tsquery(?)))", _query).
      each do |record|
      relations << record.item_relation
      end
    relations
  end
end
