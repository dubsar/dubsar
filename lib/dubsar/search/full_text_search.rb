class FullTextSearch
  attr_reader :items
  def initialize(_query_terms)
    @items = @results = []
    results = retrieve _query_terms
    load_items results
  end

  private
  def retrieve(_q)
    # use Sunspot.sarch(Model) to avoid MetaSearch conflicts
    Sunspot.search(Bala) do
      fulltext _q
    end.results
  end
  def load_items(_results)
    _results.each do |result|
      @items << Item.new(result)
    end
  end
  class Item
    attr_accessor :id, :clazz, :description
    def initialize(_result)
      @id = _result.id
      @clazz = _result.class.name
      @description = _result.describe
    end
    # to keep pg_search cpmpatibilty
    def item_id
      id
    end
    def item_relation
      clazz
    end
  end
end
