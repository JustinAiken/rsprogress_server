# frozen_string_literal: true

class FlagNoteCache

  attr_accessor :user_id, :ids

  def self.[](user_id)
    Rails.cache.fetch "flag_notes/#{user_id}" do
      self.new(user_id).retrieve!
    end
  end

  def initialize(user_id)
    @user_id = user_id
    @ids     = {}
  end

  def retrieve!
    add_flags!
    add_notes!
    ids
  end

private

  def add_flags!
    PersonalFlag
      .where(user_id: user_id)
      .pluck(:arrangement_id)
      .each do |arrangement_id|
        ids[arrangement_id] ||= []
        ids[arrangement_id] << :fc
      end
  end

  def add_notes!
    ArrangementNote
      .where(user_id: user_id)
      .pluck(:arrangement_id)
      .each do |arrangement_id|
        ids[arrangement_id] ||= []
        ids[arrangement_id] << :note
      end
  end
end
