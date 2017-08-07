class SearchService
  class << self
    ALLOWED_MODELS = %w(Question Answer Comment User)

    def call(query, model)
      return if query.empty?
      return ThinkingSphinx.search ThinkingSphinx::Query.escape(query) if model.empty?
      model.constantize.search ThinkingSphinx::Query.escape(query) if ALLOWED_MODELS.include?(model)
    end
  end
end
