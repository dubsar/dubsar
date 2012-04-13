class SearchSet < Array
  def initialize(_query, _offset = 0, _page_size = 50)
    @query = _query
    @offset = _offset
    @page_size = _page_size
  end
  def search
    @search ||= Search.query @query
  end
  def count
    @count ||= search.count
  end
  def count_items_per_relation
    @count_items_per_relation ||= Search.count_items_per_relation(@query)
  end
  def items()
    unless @items
      @items = []
      relations = Search.relations_per_query(@query)
      relations.each do |relation|
        r_clazz = relation.singularize.camelize.constantize
        r_ids = Search.items_per_relation(@query, relation)
        r_clazz.where("id IN (?)", r_ids).all.each do |item|
          @items << item
        end
      end
    end
    @items
  end
end

