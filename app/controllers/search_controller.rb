class SearchController < ApplicationController
  def index
    @search = Search.new(Brewery, params[:search])
    @search.order = 'name'
    @breweries = @search.run

    @search = Search.new(Beer, params[:search])
    @search.order = 'name'
    @beers = @search.run
  end
end
