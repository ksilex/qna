class SearchController < ApplicationController
  def index
    @result = Search.find(search_params)
  end

  private

  def search_params
    params.permit(:query, resources: [])
  end
end
