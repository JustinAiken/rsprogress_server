# frozen_string_literal: true

class ArrangementProgressStringPresenter
  include ActionView::Helpers::NumberHelper

  attr_accessor :record

  def initialize(arrangement_progress)
    @record = arrangement_progress
  end

  delegate :play_count, to: :record
  delegate :sa_play_count, to: :record
  delegate :streak, to: :record

  def mastery
    percent record.mastery
  end

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
    number_to_percentage float * 100, precision: 2
  end

  def display_pick(pick)
    return nil unless pick
    pick.split("_").last
  end

  def show_score(score)
    return nil unless score
    return nil unless score > 0
    number_with_delimiter score
  end
end
