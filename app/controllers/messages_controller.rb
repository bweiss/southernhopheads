class MessagesController < ApplicationController
  def new
    @message = Message.new
  end

  def create
    @message = Message.new(params[:message])
    if @message.valid?
      AdminMailer.contact_us(@message).deliver
      flash[:notice] = "Your message has been sent! Thank you!"
      redirect_to root_path
    else
      render :action => 'new'
    end
  end
end
