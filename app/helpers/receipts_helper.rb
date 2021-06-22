module ReceiptsHelper
  
  def placed_datetime_format(datetime, timezone)
    if (datetime.in_time_zone(timezone).to_date - Time.now.in_time_zone(timezone).to_date).to_i > -1
      day = time_ago_in_words(datetime, include_seconds: true) + " ago"
    elsif (datetime.in_time_zone(timezone).to_date - Time.now.in_time_zone(timezone).to_date).to_i == -1
      day = "Yesterday"
    elsif (datetime.in_time_zone(timezone).to_date - Time.now.in_time_zone(timezone).to_date).to_i < -1
      day = time_ago_in_words(datetime) + ' ago'
    end
    day.gsub('about ','').gsub('less than ', '')
  end
  
  def due_date_format(datetime, timezone)
    if (datetime.in_time_zone(timezone).to_date - Time.now.in_time_zone(timezone).to_date).to_i == 0
      day = "Today"
    elsif (datetime.in_time_zone(timezone).to_date - Time.now.in_time_zone(timezone).to_date).to_i == 1
      day = "Tomorrow"
    elsif (datetime.in_time_zone(timezone).to_date - Time.now.in_time_zone(timezone).to_date).to_i == -1
      day = "Yesterday"
    else
      day = datetime.in_time_zone(timezone).to_date.to_formatted_s(:rfc822)
    end
    day
  end

  def due_time_format(datetime, timestr, timezone)
    if datetime.in_time_zone(timezone) < Time.now.in_time_zone(timezone) # datetime is in the past
      time = datetime.in_time_zone(timezone).strftime("%H:%M")
    elsif datetime.in_time_zone(timezone) > Time.now.in_time_zone(timezone)
      time = timestr || "ASAP"
    else
      time = ""
    end
    time
  end

end
