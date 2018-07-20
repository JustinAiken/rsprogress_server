# frozen_string_literal: true

module InvalidatesFlagNoteCache
  extend ActiveSupport::Concern

  included do
    before_destroy :clear_flag_note_cache
    before_update  :clear_flag_note_cache
  end

  def clear_flag_note_cache
    Rails.cache.delete "flag_notes/#{user_id}"
    ArrangementProgress.where(user_id: user_id, arrangement_id: arrangement_id).pluck(:id).each do |ap_id|
      Rails.cache.delete "arrangement_progresses/#{user_id}/#{ap_id}"
    end
  end
end
