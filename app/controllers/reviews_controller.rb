class ReviewsController < ApplicationController
  before_filter :authenticate_user!, :only => [ :new, :create, :edit, :update, :destroy ]

  def index
    @reviews = Review.all.paginate(:page => params[:page], :per_page => 20)
  end

  def new
    authorize! :new, Review, :message => 'You are not authorized to make new reviews.'
    @beer = Beer.find(params[:beer_id])
    @review = Review.new
  end

  def create
    authorize! :create, Review, :message => 'You are not authorized to create reviews.'
    @beer = Beer.find(params[:beer_id])
    @review = @beer.reviews.build(params[:review])
    current_user.reviews << @review
    if @review.save
      flash[:notice] = 'Review created. Thank you.'
      redirect_to @beer
    else
      render :action => 'new'
    end
  end

  def edit
    @review = Review.find(params[:id])
    authorize! :edit, @review, :message => 'You are not authorized to edit reviews.'
  end

  def update
    @review = Review.find(params[:id])
    authorize! :update, @review, :message => 'You are not authorized to update reviews.'
    if @review.update_attributes(params[:review])
      flash[:notice] = 'Review has been updated.'
      redirect_to @review.beer
    else
      render :action => 'edit'
    end
  end

  def destroy
    @review = Review.find(params[:id])
    authorize! :destroy, @review, :message => 'Not authorized to delete reviews.'
    @beer = @review.beer
    @review.destroy
    flash[:notice] = 'Review has been deleted.'
    redirect_to @beer
  end

  def show
    @review = Review.find(params[:id])
  end
end
