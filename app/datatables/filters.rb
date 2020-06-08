# frozen_string_literal: true

module Filters
  def filter_arrangement
    ->(_column, search_string) {
      requested_keys = search_string.split(",")
      return nil unless requested_keys.present?

      SongInfo::Arrangement.arel_table[:type].in build_arrangements(requested_keys)
    }
  end

  private def build_arrangements(requested_keys)
    [].tap do |okays|
      okays << SongInfo::Arrangement.types[:lead]             if requested_keys.include?("Lead")   || requested_keys.include?("Any Guitar")
      okays << SongInfo::Arrangement.types[:rhythm]           if requested_keys.include?("Rhythm") || requested_keys.include?("Any Guitar")
      okays << SongInfo::Arrangement.types[:bass]             if requested_keys.include?("Bass")
      okays << SongInfo::Arrangement.types[:alternate_bass]   if requested_keys.include?("Bass")
      okays << SongInfo::Arrangement.types["5_string_bass"]   if requested_keys.include?("Bass")
      okays << SongInfo::Arrangement.types[:bonus_lead]       if requested_keys.include?("Bonus") || requested_keys.include?("Any Guitar")
      okays << SongInfo::Arrangement.types[:bonus_rhythm]     if requested_keys.include?("Bonus") || requested_keys.include?("Any Guitar")
      okays << SongInfo::Arrangement.types[:alternate_lead]   if requested_keys.include?("Bonus") || requested_keys.include?("Any Guitar")
      okays << SongInfo::Arrangement.types[:alternate_rhythm] if requested_keys.include?("Bonus") || requested_keys.include?("Any Guitar")
    end
  end

  def filter_type
    ->(_column, search_string) do
      requested_keys = search_string.split(",")
      return nil unless requested_keys.present?

      SongInfo::Song.arel_table[:dlc_type].in build_dlc_types(requested_keys)
    end
  end

  private def build_dlc_types(requested_keys)
    [].tap do |types|
      SongInfo::Song::DLC_TYPES.each { |type| types << type if type.in? requested_keys }
      %w{disc dlc rs1 rs1_dlc}.each { |type| types << type if requested_keys.include? "official" }
    end
  end

  def filter_flag
    ->(_column, search_string) do
      requested_keys = search_string.split(",")
      return nil unless requested_keys.present?

      ids_conds  = {flags: [], notes: []}
      conditions = []

      if requested_keys.include? "FC"
        ids_conds[:flags] = PersonalFlag.where(user_id: user_id).pluck(:arrangement_id)
      end

      if requested_keys.include? "Note"
        ids_conds[:notes] = ArrangementNote.where(user_id: user_id).pluck(:arrangement_id)
      end

      if requested_keys.include?("FC") && requested_keys.include?("Note")
        limited_ids = ids_conds[:flags] & ids_conds[:notes]
      elsif requested_keys.include?("FC")
        limited_ids = ids_conds[:flags]
      elsif requested_keys.include?("Note")
        limited_ids = ids_conds[:notes]
      end

      if requested_keys.include?("FC") || requested_keys.include?("Note")
        conditions << ArrangementProgress.arel_table[:arrangement_id].in(limited_ids)
      end

      if requested_keys.include? "Green"
        conditions << ArrangementProgress.arel_table[:mastery].gteq(1.0)
        conditions << ArrangementProgress.arel_table[:sa_pick_hard].eq(:sa_pick_hard_platinum)
      end

      if requested_keys.include? "Almost"
        conditions << ArrangementProgress.arel_table[:mastery].gteq(1.0)
        conditions << ArrangementProgress.arel_table[:sa_pick_hard].eq(:sa_pick_hard_gold)
      end

      if requested_keys.include? "Wut"
        conditions << ArrangementProgress.arel_table[:mastery].lt(1.0)
        conditions << ArrangementProgress.arel_table[:sa_pick_hard].eq(:sa_pick_hard_platinum)
      end

      return nil unless conditions.present?

      conditions.inject(nil) do |memo, condition|
        memo ? memo.and(condition) : condition
      end
    end
  end
end
