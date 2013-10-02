class BreweriesController < ApplicationController
  before_filter :authenticate_user!, :only => [ :new, :create, :edit, :update, :destroy ]

  def index
    @breweries = Brewery.order('name ASC').paginate(:page => params[:page], :per_page => 20)
  end

  def new
    authorize! :new, Brewery, :message => 'You are not authorized to make new breweries.'
    @brewery = Brewery.new
  end

  def create
    authorize! :create, Brewery, :message => 'You are not authorized to create breweries.'
    @brewery = Brewery.new(params[:brewery])
    if @brewery.save
      flash[:notice] = 'Brewery created. Thank you.'
      redirect_to @brewery
    else
      render :action => 'new'
    end
  end

  def edit
    @brewery = Brewery.find(params[:id])
    authorize! :edit, @brewery, :message => 'You are not authorized to edit breweries.'
  end

  def update
    @brewery = Brewery.find(params[:id])
    authorize! :update, @brewery, :message => 'You are not authorized to update breweries.'
    if @brewery.update_attributes(params[:brewery])
      flash[:notice] = 'Brewery has been updated.'
      redirect_to @brewery
    else
      render :action => 'edit'
    end
  end

  def destroy
    @brewery = Brewery.find(params[:id])
    authorize! :destroy, @brewery, :message => 'Not authorized to delete breweries.'
    @brewery.destroy
    flash[:notice] = 'Brewery has been deleted.'
    redirect_to brewery_path
  end

  def show
    @brewery = Brewery.find(params[:id])
  end
end
