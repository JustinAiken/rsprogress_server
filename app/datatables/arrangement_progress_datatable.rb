# frozen_string_literal: true

class ArrangementProgressDatatable < AjaxDatatablesRails::Base
  include Filters
  include DirtyHack

  def_delegators :game_progress, :user_id

  def view_columns
    @view_columns ||= {
      type:            { source: "::SongInfo::Song.dlc_type",                searchable: true,  orderable: true, cond: filter_type },
      difficulty:      { source: "::SongInfo::Arrangement.difficulty",       searchable: false, orderable: true },
      artist:          { source: "::SongInfo::Artist.artist_name_sort",      searchable: false, orderable: true },
      song:            { source: "::SongInfo::Song.song_name",               searchable: false, orderable: true },
      arrangement:     { source: "::SongInfo::Arrangement.type",             searchable: true,  orderable: false, cond: filter_arrangement },
      tuning:          { source: "::SongInfo::Arrangement.tuning",           searchable: false, orderable: true },

      play_count:      { source: "::ArrangementProgress.play_count",         searchable: false, orderable: true },
      mastery:         { source: "::ArrangementProgress.mastery",            searchable: false, orderable: true },
      date_las:        { source: "::ArrangementProgress.date_las",           searchable: false, orderable: false },

      sa_play_count:   { source: "::ArrangementProgress.sa_play_count",      searchable: false, orderable: true },
      sa_hard:         { source: "::ArrangementProgress.sa_pick_hard",       searchable: false, orderable: false },
      sa_master:       { source: "::ArrangementProgress.sa_pick_master",     searchable: false, orderable: false },
      date_sa:         { source: "::ArrangementProgress.date_sa",            searchable: false, orderable: false },

      personal_flag:   { source: "::Personalflag.type",                      searchable: true,  orderable: false, cond: filter_flag }
    }
  end

  def data
    record_ids.map do |record_id|
      Rails.cache.fetch "arrangement_progresses/#{user_id}/#{record_id}" do
        RecordCacher.for_record uncached_records[record_id][0]
      end
    end
  end

private

  def record_ids
    @record_ids ||= records.pluck(:id)
  end

  def uncached_records
    @uncached_records ||= records.where(id: uncached_ids).group_by(&:id)
  end

  def uncached_ids
    record_ids.reject { |record_id| Rails.cache.exist? "arrangement_progresses/#{user_id}/#{record_id}" }
  end

  def game_progress
    options[:game_progress]
  end

  def get_raw_records
    @raw_records ||= ArrangementProgress
      .up_to(game_progress)
      .includes(arrangement:  {song: :artist})
      .references(arrangements: {songs: :artists})
  end
end
