module ReceiptsHelper
  def due_date_format(datetime, timezone)
    if (datetime.in_time_zone(timezone).to_date - Time.now.in_time_zone(timezone).to_date).to_i == 0
      day = "Today "
    elsif (datetime.in_time_zone(timezone).to_date - Time.now.in_time_zone(timezone).to_date).to_i == 1
      day = "Tomorrow at "
    elsif (datetime.in_time_zone(timezone).to_date - Time.now.in_time_zone(timezone).to_date).to_i == -1
      day = "Yesterday at "
    elsif (datetime.in_time_zone(timezone).to_date - Time.now.in_time_zone(timezone).to_date).to_i > 0
      day = datetime.in_time_zone(timezone).to_date.to_formatted_s(:rfc822) + " at "
    else
      day = datetime.in_time_zone(timezone).to_date.to_formatted_s(:rfc822) + " "
    end
    day
  end

  def due_time_format(datetime, timestr, timezone)
    if (datetime.in_time_zone(timezone).to_date - Time.now.in_time_zone(timezone).to_date).to_i >= 0
      time = timestr || "ASAP"
    else
      time = ""
    end
    time
  end
end
