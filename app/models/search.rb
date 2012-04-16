class Search < ActiveRecord::Base
  self.abstract_class = true
  def self.cloud
    solr_url = Sunspot.config.solr.url
    solr = RSolr::Ext.connect url: solr_url
    #params = {:queries => '*:*', :facets => {:fields => ['tokens']}, :rows => 0}
    params = {queries: '*:*', facets: {fields: ['tokens']}, rows: 0}
    results = solr.find params
    tokens = results['facet_counts']['facet_fields']['tokens']
    to_jqcloud(tokens.first(30))
  end
  def self.to_jqcloud(array, json="",index=0)
    return json if index == array.length
    json << "[" if (index == 0 )
    json << %Q({"text": "#{array[index]}", "weight": #{array[index + 1]}})
    if (index < array.length - 2)
      json << "," 
    else
      json << "]"
    end
    to_jqcloud(array, json, index + 2)
  end
  
  private
  # OLD STUFF
  # DELENDA
  class DBSearch
    def self.to_tsquery(_q)
      return unless _q.class == String
      # "a b" -> "a & b
      _q.strip.gsub /\s+/, " & "
    end
    def self.query(q)
      q = to_tsquery(q)
      where("content @@ to_tsquery(?)", q) 
    end
    def self.find(q)
      Sunspot.search(Bala) {|q| q.keywords q}
    end
    def self.db_cloud(_limit=40)
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
end
