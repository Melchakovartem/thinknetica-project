class SearchController < ApplicationController
  respond_to :html

  def search
    @results = SearchService.call(params[:q], params[:model])
    respond_with @results
  end
end
