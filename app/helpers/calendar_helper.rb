module CalendarHelper
  def month_link(month_date)
    link_to(I18n.localize(month_date, :format => "%B"), {:month => month_date.month, :year => month_date.year})
  end
  
  # custom options for this calendar
  def event_calendar_opts
    { 
      :year => @year,
      :month => @month,
      :event_strips => @event_strips,
      :month_name_text => I18n.localize(@shown_month, :format => "%B %Y"),
      :previous_month_text => "<< " + month_link(@shown_month.prev_month),
      :next_month_text => month_link(@shown_month.next_month) + " >>"    }
  end

  def event_calendar
    # args is an argument hash containing :event, :day, and :options
    calendar event_calendar_opts do |args|
      event = args[:event]
      %(<a href="/events/#{event.id}" title="#{h(event.title)}">#{h(event.title)}</a>)
      #start_time = "#{h(event.start_at.strftime('%I').to_i.to_s)}#{event.start_at.min > 0 ? ":#{h(event.start_at.min.to_s.rjust(2, '0'))}" : ''}#{h(event.start_at.strftime('%p').downcase)}"
      #%(<a href="/events/#{event.id}" title="#{h(event.title)}"><b>#{start_time}</b> #{h(event.title)}</a>)
    end
  end
end
