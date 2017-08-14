class SearchService
  ALLOWED_MODELS = %w(Everywhere Question Answer Comment User)

  class << self
    def call(query, model)
      return if query.empty?
      return ThinkingSphinx.search ThinkingSphinx::Query.escape(query) if model == ALLOWED_MODELS.first
      model.constantize.search ThinkingSphinx::Query.escape(query) if ALLOWED_MODELS.include?(model)
    end
  end
end
