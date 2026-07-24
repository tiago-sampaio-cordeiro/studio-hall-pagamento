module ApplicationHelper
  def format_hours(decimal_hours)
    total_seconds = (decimal_hours * 3600).round
    hours = total_seconds / 3600
    minutes = (total_seconds % 3600) / 60
    seconds = total_seconds % 60
    format("%02d:%02d:%02d", hours, minutes, seconds)
  end
end