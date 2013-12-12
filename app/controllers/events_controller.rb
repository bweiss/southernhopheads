class EventsController < ApplicationController
  before_filter :authenticate_user!, :only => [ :new, :create, :edit, :update, :destroy, :queue, :publish, :email ]

  def index
    @events = Event.published.order('updated_at DESC').paginate(:page => params[:page], :per_page => 10)
  end

  def new
    authorize! :new, Event, :message => 'Not authorized to create events.'
    @event = Event.new
  end

  def create
    authorize! :create, Event, :message => 'Not authorized to create events.'
    @event = Event.new(params[:event])
    @event.user_id = current_user.id
    @event.end_at = @event.start_at if @event.end_at.nil?
    if @event.save
      flash[:notice] = 'Event created. Thank you!'
      redirect_to @event
    else
      render :action => 'new'
    end
  end

  def show
    if user_signed_in?
      if current_user.has_role?(:admin)
        @event = @commentable = Event.find(params[:id])
      else
        @event = @commentable = Event.published.find(params[:id])
      end
    else
      @event = @commentable = Event.published.find(params[:id])
    end
    @comments = @event.comments.paginate(:page => params[:page], :per_page => 10)
  end

  def edit
    @event = Event.find(params[:id])
    authorize! :edit, @event, :message => 'Not authorized to edit events.'
  end

  def update
    @event = Event.find(params[:id])
    authorize! :update, @event, :message => 'Not authorized to update events.'
    if @event.update_attributes(params[:event])
      flash[:notice] = 'Event has been updated.'
      redirect_to @event
    else
      render :action => 'edit'
    end
  end

  def destroy
    @event = Event.find(params[:id])
    authorize! :destroy, @event, :message => 'Not authorized to delete events.'
    @event.destroy
    flash[:notice] = 'Event has been deleted.'
    redirect_to root_path
  end

  def queue
    authorize! :queue, Event, :message => 'Not authorized to access event queue.'
    @events = Event.not_published.order('updated_at DESC')
  end

  def publish
    @event = Event.find(params[:id])
    authorize! :publish, @event, :message => 'Not authorized to publish this event.'
    @event.published = true
    if @event.save
      flash[:notice] = 'Event has been published.'
    else
      flash[:error] = 'There was an error publishing this event.'
    end
    redirect_to event_queue_path
  end

  def email
    @event = Event.find(params[:id])
    authorize! :email, @event, :message => 'Not authorized to email this event.'
    @recipients = User.wants_emails_about_events
    if @event.valid? and !@recipients.empty?
      @recipients.each do |u|
        UserMailer.email_event(u, @event).deliver
      end
      flash[:notice] = 'Your message has been sent! Thank you!'
      redirect_to @event
    else
      flash[:error] = 'Error. Email not sent.'
      redirect_to @event
    end
  end
end
