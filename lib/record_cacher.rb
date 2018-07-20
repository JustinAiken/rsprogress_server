# frozen_string_literal: true

class RecordCacher
  attr_reader :ap

  def self.for_record(record)
    self.new(record).data
  end

  def initialize(record)
    @ap = ArrangementProgressPresenter.new(record)
  end

  def data
    {
      type:            ap.dlc_type,
      difficulty:      ap.difficulty,
      artist:          ap.artist_name,
      song:            ap.song_name,
      arrangement:     ap.arrangement_type,
      tuning:          ap.tuning_info,
      play_count:      ap.play_count,
      mastery:         ap.mastery,
      date_las:        ap.date_las,
      sa_play_count:   ap.sa_play_count,
      sa_hard:         ap.sa_hard,
      sa_master:       ap.sa_master,
      date_sa:         ap.date_sa,
      personal_flag:   ap.personal_flag,
      DT_RowClass:     ap.row_class,
      DT_RowID:        ap.row_id
    }
  end
end
