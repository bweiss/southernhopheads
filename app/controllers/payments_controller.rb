class PaymentsController < ApplicationController
  before_filter :authenticate_user!, :only => [ :index, :new, :create, :edit, :update, :destroy ]

  def index
    authorize! :index, Payment, :message => 'You are not authorized to see payment indexes.'
    @user = User.find(params[:user_id])
    @payment = @user.payment
  end

  def new
    authorize! :new, Payment, :message => 'You are not authorized to make new payments.'
    @user = User.find(params[:user_id])
    @payment = Payment.new
  end

  def create
    authorize! :create, Payment, :message => 'You are not authorized to create payments.'
    @user = User.find(params[:user_id])
    @payment = @user.build_payment(params[:payment], :as => :treasurer)
    if @payment.save
      flash[:notice] = 'Payment created. Thank you.'
      redirect_to @payment
    else
      render :action => 'new'
    end
  end

  def edit
    @payment = Payment.find(params[:id])
    authorize! :edit, @payment, :message => 'You are not authorized to edit payments.'
  end

  def update
    authorize! :update, Payment, :message => 'You are not authorized to update payments.'
    @payment = Payment.find(params[:id])
    if @payment.update_attributes(params[:payment], :as => :treasurer)
      flash[:notice] = 'Payment has been updated.'
      redirect_to @payment
    else
      render :action => 'edit'
    end
  end

  def destroy
    @payment = Payment.find(params[:id])
    authorize! :destroy, @payment, :message => 'Not authorized to delete payments.'
    @payment.destroy
    flash[:notice] = 'Payment has been deleted.'
    redirect_to forums_path
  end

  def show
    @payment = Payment.find(params[:id])

  end
end
