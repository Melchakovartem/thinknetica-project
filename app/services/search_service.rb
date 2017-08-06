class SearchService
  class << self
    def call(query, model)
      return ThinkingSphinx.search query if model.empty?
      model.capitalize.constantize.search query
    end

    private
  end
end
