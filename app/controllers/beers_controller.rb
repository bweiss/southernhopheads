class BeersController < ApplicationController
  before_filter :authenticate_user!, :only => [ :new, :create, :edit, :update, :destroy ]

  def index
    @beers = Beer.order('name ASC').paginate(:page => params[:page], :per_page => 20)
  end

  def new
    authorize! :new, Beer, :message => 'You are not authorized to make new beers.'
    @brewery = Brewery.find(params[:brewery_id])
    @beer = Beer.new
  end

  def create
    authorize! :create, Beer, :message => 'You are not authorized to create beers.'
    @brewery = Brewery.find(params[:brewery_id])
    @beer = @brewery.beers.build(params[:beer])
    if @beer.save
      flash[:notice] = 'Beer created. Thank you.'
      redirect_to @beer
    else
      render :action => 'new'
    end
  end

  def edit
    @beer = Beer.find(params[:id])
    authorize! :edit, @beer, :message => 'You are not authorized to edit beers.'
  end

  def update
    @beer = Beer.find(params[:id])
    authorize! :update, @beer, :message => 'You are not authorized to update beers.'
    if @beer.update_attributes(params[:beer])
      flash[:notice] = 'Beer has been updated.'
      redirect_to @beer
    else
      render :action => 'edit'
    end
  end

  def destroy
    @beer = Beer.find(params[:id])
    authorize! :destroy, @beer, :message => 'Not authorized to delete beers.'
    @beer.destroy
    flash[:notice] = 'Beer has been deleted.'
    redirect_to beer_path
  end

  def show
    @beer = Beer.find(params[:id])
    @beer_reviews = get_beer_ratings(@beer)
  end

  private

    def get_beer_ratings(beer)
      if beer.reviews.count > 0
        beer_scores = beer.reviews.pluck(:score).map(&:to_f)
        beer_avg_score = beer_scores.sum / beer_scores.size
        all_scores = Review.pluck(:score).map(&:to_f)
        all_avg_score = all_scores.sum / all_scores.size
        beer_rating = ((all_scores.size * all_avg_score) + (beer_scores.size * beer_avg_score)) / (all_scores.size + beer_scores.size)
        return { :score => beer_avg_score.round(1), :rating => beer_rating.round(1) }
      else
        return { :score => nil, :rating => nil }
      end
    end
end
