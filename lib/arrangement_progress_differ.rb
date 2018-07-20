# frozen_string_literal: true

class ArrangementProgressDiffer

  attr_accessor :current_progress, :previous_progress

  def initialize(arrangement_progress, presenter_klass: ArrangementProgressPresenter)
    @current_progress  = presenter_klass.new(arrangement_progress)
    @previous_progress = presenter_klass.new(arrangement_progress.previous_progress)
  end

  THINGS_TO_CHECK = {
    mastery:         "Mastery",
    streak:          "Streak",
    play_count:      "Play Count",
    sa_play_count:   "SA Play Count",
    sa_pick_hard:    "SA Pick (Hard)",
    sa_pick_master:  "SA Pick (Master)",
    sa_score_hard:   "SA Score (Hard)",
    sa_score_master: "SA Score (Master)"
  }

  def diffs
    return first_times unless previous_progress.record.present?

    THINGS_TO_CHECK.keys.inject({}) do |memo, thing|
      if current_progress.send(thing) != previous_progress.send(thing)
        memo[THINGS_TO_CHECK[thing]] = [
          previous_progress.send(thing),
          current_progress.send(thing)
        ]
      end
      memo
    end
  end

  def first_times
    THINGS_TO_CHECK.keys.inject({}) do |memo, thing|
      memo[THINGS_TO_CHECK[thing]] = [
        nil,
        current_progress.send(thing)
      ] if current_progress.send(thing)
      memo
    end
  end
end
