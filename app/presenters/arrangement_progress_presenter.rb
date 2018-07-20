# frozen_string_literal: true

class ArrangementProgressPresenter
  include ActionView::Helpers::NumberHelper

  attr_accessor :record

  def initialize(arrangement_progress)
    @record = arrangement_progress
  end

  def dlc_type
    return "" if record.arrangement.song.dlc_type == "disc"
    %Q{<span class="label label-default">#{record.arrangement.song.dlc_type}</span>}.html_safe
  end

  def difficulty
    record.arrangement.difficulty
  end

  def artist_name
    record.arrangement.song.artist.artist_name
  end

  def song_name
    record.arrangement.song.song_name
  end

  def arrangement_type
    %Q{<span class="label label-default">#{record.arrangement.type.titlecase}</span>}.html_safe
  end

  def tuning_info
    t = record.arrangement.tuning.to_s
    t << " (#{record.arrangement.tuning_offset})" if record.arrangement.tuning_offset
    t << " (Capo #{record.arrangement.capo})"     if record.arrangement.capo.present?
    t
  end

  def play_count
    record.play_count
  end

  def mastery
    percent record.mastery
  end

  def date_las
    date_string record.date_las
  end

  def sa_play_count
    record.sa_play_count
  end

  def sa_hard
    score_attack record, :hard
  end

  def sa_master
    score_attack record, :master
  end

  def date_sa
    date_string record.date_sa
  end

  FLAGS = {
    note: %Q{ <span class="label label-info"> <span class="glyphicon glyphicon-pencil"></span></span>},
    fc:   %Q{ <span class="label label-success">FC</span>},
  }.freeze

  def personal_flag
    array_of_flags = FlagNoteCache[record.user_id][record.arrangement_id]
    return nil unless array_of_flags.present?

    array_of_flags
      .map { |word| FLAGS[word] }
      .join("")
      .html_safe
  end

  def row_class
    return nil unless record.sa_pick_hard_platinum? && record.mastery
    return nil unless record.mastery >= 1
    "success"
  end

  def row_id
    "row_#{record.id}"
  end

  delegate :diffs, :streak, to: :record

  def sa_pick_hard
    display_pick record.sa_pick_hard
  end

  def sa_pick_master
    display_pick record.sa_pick_master
  end

  def sa_score_hard
    show_score record.sa_score_hard
  end

  def sa_score_master
    show_score record.sa_score_master
  end

private

  def percent(float)
    return nil unless float
    string = number_to_percentage float * 100, precision: 2
    style  = case (float * 100)
    when 100..200 then "success"
    when 90..100  then "primary"
    when 70..90   then "info"
    when 30..70   then "warning"
    when 00..30   then "danger"
    end
    return string unless style
    %Q{<span class="label label-#{style}">#{string}</span>}.html_safe
  end

  def date_string(somedate)
    return nil unless somedate
    somedate.strftime "%Y-%m-%d %-l:%M%P"
  end

  def score_attack(record, mode)
    [
      display_pick(record.send("sa_pick_#{mode}")),
      show_score(record.send("sa_score_#{mode}"))
    ].join("</br>").html_safe
  end

  PICK_STYLES = {
    "platinum" => "success",
    "gold"     => "primary",
    "silver"   => "info",
    "bronze"   => "warning",
    "fail"     => "danger"
  }.freeze

  def display_pick(pick)
    return nil unless pick
    text  = pick.split("_").last
    style = PICK_STYLES[text]
    return text unless style
    %Q{<span class="label label-#{style}">#{text}</span>}
  end

  def show_score(score)
    return nil unless score
    return nil unless score > 0
    number_with_delimiter score
  end
end
