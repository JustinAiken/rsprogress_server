# frozen_string_literal: true

module ProfileHelper

  def pretty_time(total_seconds)
    seconds = total_seconds % 60
    minutes = (total_seconds / 60) % 60
    hours   = total_seconds / (60 * 60)

    format "%03d:%02d:%02d", hours, minutes, seconds
  end
end
